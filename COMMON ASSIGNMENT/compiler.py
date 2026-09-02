import re


# ============================================================
# SYNTAX TREE
# ============================================================

class Node:
    def __init__(self, value, left=None, right=None):
        self.value = value
        self.left = left
        self.right = right


# ============================================================
# TOKENIZER
# ============================================================

def tokenize(expression):
    pattern = r'[A-Za-z_][A-Za-z0-9_]*|\d+(?:\.\d+)?|[()+\-*/^=]'
    return re.findall(pattern, expression)


# ============================================================
# PARSER
# ============================================================

class Parser:

    def __init__(self, tokens):
        self.tokens = tokens
        self.position = 0

    def current(self):
        if self.position < len(self.tokens):
            return self.tokens[self.position]
        return None

    def eat(self, expected=None):
        token = self.current()

        if expected and token != expected:
            raise ValueError(
                f"Expected '{expected}' but found '{token}'"
            )

        self.position += 1
        return token

    def parse(self):
        variable = self.eat()

        self.eat("=")

        expression = self.parse_expression()

        if self.current() is not None:
            raise ValueError(
                f"Unexpected token: {self.current()}"
            )

        return Node(
            "=",
            Node(variable),
            expression
        )

    def parse_expression(self):

        node = self.parse_term()

        while self.current() in ("+", "-"):

            operator = self.eat()

            right = self.parse_term()

            node = Node(
                operator,
                node,
                right
            )

        return node

    def parse_term(self):

        node = self.parse_power()

        while self.current() in ("*", "/"):

            operator = self.eat()

            right = self.parse_power()

            node = Node(
                operator,
                node,
                right
            )

        return node

    def parse_power(self):

        node = self.parse_factor()

        if self.current() == "^":

            self.eat("^")

            right = self.parse_power()

            node = Node(
                "^",
                node,
                right
            )

        return node

    def parse_factor(self):

        token = self.current()

        if token == "(":

            self.eat("(")

            node = self.parse_expression()

            self.eat(")")

            return node

        return Node(self.eat())


# ============================================================
# SYNTAX TREE TEXT
# ============================================================

def tree_to_text(node, level=0, prefix=""):

    if node is None:
        return ""

    result = (
        "    " * level
        + prefix
        + str(node.value)
        + "\n"
    )

    if node.left:
        result += tree_to_text(
            node.left,
            level + 1,
            "L--- "
        )

    if node.right:
        result += tree_to_text(
            node.right,
            level + 1,
            "R--- "
        )

    return result


# ============================================================
# THREE ADDRESS CODE
# ============================================================

class TACGenerator:

    def __init__(self):

        self.temp_count = 0

        self.code = []

    def new_temp(self):

        self.temp_count += 1

        return f"t{self.temp_count}"

    def generate(self, node):

        # Assignment
        if node.value == "=":

            value = self.generate(
                node.right
            )

            self.code.append(
                (
                    node.left.value,
                    "=",
                    value,
                    ""
                )
            )

            return node.left.value

        # Leaf
        if node.left is None and node.right is None:

            return node.value

        left = self.generate(
            node.left
        )

        right = self.generate(
            node.right
        )

        temp = self.new_temp()

        self.code.append(
            (
                temp,
                node.value,
                left,
                right
            )
        )

        return temp


def tac_to_text(tac):

    lines = []

    for result, operator, left, right in tac:

        if operator == "=":

            lines.append(
                f"{result} = {left}"
            )

        else:

            lines.append(
                f"{result} = {left} {operator} {right}"
            )

    return "\n".join(lines)


# ============================================================
# QUADRUPLES
# ============================================================

def generate_quadruples(tac):

    quadruples = []

    for result, operator, left, right in tac:

        if operator == "=":

            quadruples.append(
                ("=", left, "-", result)
            )

        else:

            quadruples.append(
                (
                    operator,
                    left,
                    right,
                    result
                )
            )

    return quadruples


def quadruples_to_text(quadruples):

    lines = []

    lines.append(
        f"{'Operator':<10}"
        f"{'Arg1':<15}"
        f"{'Arg2':<15}"
        f"{'Result':<15}"
    )

    lines.append("-" * 55)

    for op, arg1, arg2, result in quadruples:

        lines.append(
            f"{op:<10}"
            f"{arg1:<15}"
            f"{arg2:<15}"
            f"{result:<15}"
        )

    return "\n".join(lines)


# ============================================================
# TRIPLES
# ============================================================

def generate_triples(tac):

    triples = []

    temp_index = {}

    for index, (
        result,
        operator,
        left,
        right
    ) in enumerate(tac):

        if left in temp_index:

            left = f"({temp_index[left]})"

        if right in temp_index:

            right = f"({temp_index[right]})"

        if operator == "=":

            triples.append(
                ("=", left, result)
            )

        else:

            triples.append(
                (
                    operator,
                    left,
                    right
                )
            )

        temp_index[result] = index

    return triples


def triples_to_text(triples):

    lines = []

    lines.append(
        f"{'Index':<8}"
        f"{'Operator':<12}"
        f"{'Arg1':<15}"
        f"{'Arg2':<15}"
    )

    lines.append("-" * 50)

    for index, triple in enumerate(triples):

        op, arg1, arg2 = triple

        lines.append(
            f"{index:<8}"
            f"{op:<12}"
            f"{arg1:<15}"
            f"{arg2:<15}"
        )

    return "\n".join(lines)


# ============================================================
# CONSTANT FOLDING
# ============================================================

def is_number(value):

    try:

        float(value)

        return True

    except:

        return False


def calculate(operator, a, b):

    a = float(a)

    b = float(b)

    if operator == "+":

        return a + b

    if operator == "-":

        return a - b

    if operator == "*":

        return a * b

    if operator == "/":

        if b == 0:
            return None

        return a / b

    if operator == "^":

        return a ** b

    return None


def format_number(value):

    if value.is_integer():

        return str(int(value))

    return str(value)


def constant_folding(tac):

    optimized = []

    constants = {}

    changes = []

    for result, operator, left, right in tac:

        if operator == "=":

            if left in constants:

                left = constants[left]

            optimized.append(
                (
                    result,
                    operator,
                    left,
                    right
                )
            )

            continue

        if left in constants:

            left = constants[left]

        if right in constants:

            right = constants[right]

        if (
            is_number(left)
            and
            is_number(right)
        ):

            value = calculate(
                operator,
                left,
                right
            )

            if value is not None:

                value = format_number(
                    value
                )

                constants[result] = value

                changes.append(
                    f"{result} = "
                    f"{left} {operator} {right}"
                    f"  ->  "
                    f"{result} = {value}"
                )

                optimized.append(
                    (
                        result,
                        "=",
                        value,
                        ""
                    )
                )

                continue

        optimized.append(
            (
                result,
                operator,
                left,
                right
            )
        )

    return optimized, changes


# ============================================================
# COMMON SUBEXPRESSION ELIMINATION
# ============================================================

def common_subexpression_elimination(tac):

    optimized = []

    expressions = {}

    replacements = {}

    changes = []

    for result, operator, left, right in tac:

        if left in replacements:

            left = replacements[left]

        if right in replacements:

            right = replacements[right]

        if operator == "=":

            optimized.append(
                (
                    result,
                    operator,
                    left,
                    right
                )
            )

            continue

        expression = (
            operator,
            left,
            right
        )

        if expression in expressions:

            old_result = expressions[
                expression
            ]

            replacements[result] = old_result

            changes.append(
                f"{result} = "
                f"{left} {operator} {right}"
                f"  ->  reused {old_result}"
            )

        else:

            expressions[
                expression
            ] = result

            optimized.append(
                (
                    result,
                    operator,
                    left,
                    right
                )
            )

    return optimized, changes


# ============================================================
# DEAD CODE ELIMINATION
# ============================================================

def dead_code_elimination(tac):

    if not tac:

        return tac, []

    needed = set()

    changes = []

    # The final result is required
    needed.add(
        tac[-1][0]
    )

    changed = True

    while changed:

        changed = False

        for (
            result,
            operator,
            left,
            right
        ) in reversed(tac):

            if result in needed:

                if (
                    left
                    and
                    left not in needed
                ):

                    needed.add(left)

                    changed = True

                if (
                    right
                    and
                    right not in needed
                    and
                    not is_number(right)
                ):

                    needed.add(right)

                    changed = True

    optimized = []

    for instruction in tac:

        result = instruction[0]

        if result in needed:

            optimized.append(
                instruction
            )

        else:

            changes.append(
                f"Removed dead instruction: "
                f"{tac_to_text([instruction])}"
            )

    return optimized, changes


# ============================================================
# COMPLETE COMPILER
# ============================================================

def compile_expression(expression):

    # ----------------------------
    # Parsing
    # ----------------------------

    tokens = tokenize(
        expression
    )

    parser = Parser(tokens)

    syntax_tree = parser.parse()

    # ----------------------------
    # TAC
    # ----------------------------

    generator = TACGenerator()

    generator.generate(
        syntax_tree
    )

    tac = generator.code

    # ----------------------------
    # Representations
    # ----------------------------

    quadruples = generate_quadruples(
        tac
    )

    triples = generate_triples(
        tac
    )

    # ----------------------------
    # Optimization 1
    # ----------------------------

    after_cf, cf_changes = constant_folding(
        tac
    )

    # ----------------------------
    # Optimization 2
    # ----------------------------

    after_cse, cse_changes = (
        common_subexpression_elimination(
            after_cf
        )
    )

    # ----------------------------
    # Optimization 3
    # ----------------------------

    optimized, dce_changes = (
        dead_code_elimination(
            after_cse
        )
    )

    # ----------------------------
    # Optimization reports
    # ----------------------------

    if cf_changes:

        cf_report = (
            "CONSTANT FOLDING\n"
            "========================\n\n"
            + "\n".join(cf_changes)
            + "\n\n"
            + f"Expressions optimized: "
            f"{len(cf_changes)}"
        )

    else:

        cf_report = (
            "CONSTANT FOLDING\n"
            "========================\n\n"
            "No constant expressions "
            "found in this input.\n\n"
            "This is normal when the "
            "operands contain variables."
        )

    if cse_changes:

        cse_report = (
            "COMMON SUBEXPRESSION "
            "ELIMINATION\n"
            "========================\n\n"
            + "\n".join(cse_changes)
            + "\n\n"
            + f"Common expressions eliminated: "
            f"{len(cse_changes)}"
        )

    else:

        cse_report = (
            "COMMON SUBEXPRESSION "
            "ELIMINATION\n"
            "========================\n\n"
            "No repeated subexpressions "
            "found in this input."
        )

    if dce_changes:

        dce_report = (
            "DEAD CODE ELIMINATION\n"
            "========================\n\n"
            + "\n".join(dce_changes)
            + "\n\n"
            + f"Dead instructions removed: "
            f"{len(dce_changes)}"
        )

    else:

        dce_report = (
            "DEAD CODE ELIMINATION\n"
            "========================\n\n"
            "No dead instructions found.\n\n"
            "All generated instructions "
            "contribute to the final result."
        )

    return {

        "tree":
            tree_to_text(
                syntax_tree
            ),

        "tokens":
            " ".join(tokens),

        "tac":
            tac_to_text(tac),

        "quadruples":
            quadruples_to_text(
                quadruples
            ),

        "triples":
            triples_to_text(
                triples
            ),

        "constant_folding":
            cf_report,

        "cse":
            cse_report,

        "dead_code":
            dce_report,

        "optimized":
            tac_to_text(
                optimized
            ),

        "non_optimized_count":
            len(tac),

        "optimized_count":
            len(optimized),

        "removed":
            len(tac) - len(optimized)
    }