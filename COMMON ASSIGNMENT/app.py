import tkinter as tk
from tkinter import ttk, messagebox

from compiler import compile_expression


# ============================================================
# MAIN WINDOW
# ============================================================

root = tk.Tk()

root.title("Intermediate Code Generator & Optimizer")
root.geometry("1150x780")
root.minsize(950, 650)


# ============================================================
# TITLE
# ============================================================

title = tk.Label(
    root,
    text="Intermediate Code Generator & Optimizer",
    font=("Arial", 22, "bold")
)

title.pack(pady=(15, 3))


subtitle = tk.Label(
    root,
    text="Syntax Tree  →  TAC  →  Quadruples / Triples  →  Optimization",
    font=("Arial", 11)
)

subtitle.pack(pady=(0, 12))


# ============================================================
# INPUT SECTION
# ============================================================

input_frame = tk.Frame(root)

input_frame.pack(
    fill="x",
    padx=25,
    pady=5
)


input_label = tk.Label(
    input_frame,
    text="Enter Expression:",
    font=("Arial", 12, "bold")
)

input_label.pack(anchor="w")


expression_box = tk.Entry(
    input_frame,
    font=("Consolas", 12)
)

expression_box.pack(
    fill="x",
    pady=8,
    ipady=7
)


# Default expression
expression_box.insert(
    0,
    "finalValue = ((principal * rate * time) / 100) + (principal * (1 + rate / 100)^time) - fees"
)


# ============================================================
# BUTTON FUNCTIONS
# ============================================================

def generate_code():

    expression = expression_box.get().strip()

    if not expression:
        messagebox.showwarning(
            "Input Required",
            "Please enter an expression."
        )
        return

    try:

        result = compile_expression(expression)

        # -----------------------------------------
        # Draw Syntax Tree
        # -----------------------------------------

        draw_syntax_tree_from_text(result["tree"])

        # -----------------------------------------
        # TAC
        # -----------------------------------------

        tac_box.config(state="normal")
        tac_box.delete("1.0", tk.END)
        tac_box.insert(tk.END, result["tac"])
        tac_box.config(state="disabled")

        # -----------------------------------------
        # Quadruples
        # -----------------------------------------

        quadruple_box.config(state="normal")
        quadruple_box.delete("1.0", tk.END)
        quadruple_box.insert(
            tk.END,
            result["quadruples"]
        )
        quadruple_box.config(state="disabled")

        # -----------------------------------------
        # Triples
        # -----------------------------------------

        triple_box.config(state="normal")
        triple_box.delete("1.0", tk.END)
        triple_box.insert(
            tk.END,
            result["triples"]
        )
        triple_box.config(state="disabled")

        # -----------------------------------------
        # Constant Folding
        # -----------------------------------------

        constant_box.config(state="normal")
        constant_box.delete("1.0", tk.END)
        constant_box.insert(
            tk.END,
            result["constant_folding"]
        )
        constant_box.config(state="disabled")

        # -----------------------------------------
        # Common Subexpression
        # -----------------------------------------

        cse_box.config(state="normal")
        cse_box.delete("1.0", tk.END)
        cse_box.insert(
            tk.END,
            result["cse"]
        )
        cse_box.config(state="disabled")

        # -----------------------------------------
        # Dead Code Elimination
        # -----------------------------------------

        dce_box.config(state="normal")
        dce_box.delete("1.0", tk.END)
        dce_box.insert(
            tk.END,
            result["dead_code"]
        )
        dce_box.config(state="disabled")

        # -----------------------------------------
        # Optimized TAC
        # -----------------------------------------

        optimized_box.config(state="normal")
        optimized_box.delete("1.0", tk.END)
        optimized_box.insert(
            tk.END,
            result["optimized"]
        )
        optimized_box.config(state="disabled")

        # -----------------------------------------
        # Comparison
        # -----------------------------------------

        non_optimized_label.config(
            text=str(result["non_optimized_count"])
        )

        optimized_label.config(
            text=str(result["optimized_count"])
        )

        removed_label.config(
            text=str(result["removed"])
        )

        if result["non_optimized_count"] > 0:

            reduction = (
                result["removed"]
                / result["non_optimized_count"]
            ) * 100

            efficiency_label.config(
                text=f"{reduction:.2f}%"
            )

        else:
            efficiency_label.config(text="0%")

    except Exception as error:

        messagebox.showerror(
            "Compilation Error",
            str(error)
        )


def clear_all():

    expression_box.delete(0, tk.END)

    # Clear syntax tree
    tree_canvas.delete("all")

    # Clear output boxes
    for box in [
    tac_box,
    quadruple_box,
    triple_box,
    constant_box,
    cse_box,
    dce_box,
    optimized_box
]:

        box.config(state="normal")
        box.delete("1.0", tk.END)
        box.config(state="disabled")

    # Reset comparison
    non_optimized_label.config(text="-")
    optimized_label.config(text="-")
    removed_label.config(text="-")
    efficiency_label.config(text="-")


# ============================================================
# BUTTONS
# ============================================================

button_frame = tk.Frame(root)

button_frame.pack(pady=5)


generate_button = tk.Button(
    button_frame,
    text="GENERATE CODE",
    command=generate_code,
    font=("Arial", 11, "bold"),
    padx=25,
    pady=8,
    cursor="hand2"
)

generate_button.pack(
    side="left",
    padx=8
)


clear_button = tk.Button(
    button_frame,
    text="CLEAR",
    command=clear_all,
    font=("Arial", 11, "bold"),
    padx=25,
    pady=8,
    cursor="hand2"
)

clear_button.pack(
    side="left",
    padx=8
)


# ============================================================
# NOTEBOOK
# ============================================================

notebook = ttk.Notebook(root)

notebook.pack(
    fill="both",
    expand=True,
    padx=25,
    pady=15
)


# ============================================================
# SYNTAX TREE TAB
# ============================================================

tree_frame = ttk.Frame(notebook)

notebook.add(
    tree_frame,
    text="Syntax Tree"
)


# Canvas + scrollbars
tree_canvas = tk.Canvas(
    tree_frame,
    background="white",
    highlightthickness=1
)

tree_vertical = ttk.Scrollbar(
    tree_frame,
    orient="vertical",
    command=tree_canvas.yview
)

tree_horizontal = ttk.Scrollbar(
    tree_frame,
    orient="horizontal",
    command=tree_canvas.xview
)

tree_canvas.configure(
    yscrollcommand=tree_vertical.set,
    xscrollcommand=tree_horizontal.set
)


tree_vertical.pack(
    side="right",
    fill="y"
)

tree_horizontal.pack(
    side="bottom",
    fill="x"
)

tree_canvas.pack(
    side="left",
    fill="both",
    expand=True
)


# ============================================================
# TEXT OUTPUT TABS
# ============================================================

def create_text_tab(name):

    frame = ttk.Frame(notebook)

    notebook.add(
        frame,
        text=name
    )

    box = tk.Text(
        frame,
        font=("Consolas", 11),
        wrap="none",
        padx=15,
        pady=15
    )

    box.pack(
        fill="both",
        expand=True,
        padx=8,
        pady=8
    )

    box.config(
        state="disabled"
    )

    return box


tac_box = create_text_tab(
    "Three Address Code"
)

quadruple_box = create_text_tab(
    "Quadruples"
)

triple_box = create_text_tab(
    "Triples"
)

constant_box = create_text_tab(
    "Constant Folding"
)

cse_box = create_text_tab(
    "Common Subexpression"
)

dce_box = create_text_tab(
    "Dead Code Elimination"
)

optimized_box = create_text_tab(
    "Optimized TAC"
)


# ============================================================
# COMPARISON TAB
# ============================================================

comparison_frame = ttk.Frame(
    notebook
)

notebook.add(
    comparison_frame,
    text="Comparison"
)


heading = tk.Label(
    comparison_frame,
    text="Optimization Comparison",
    font=("Arial", 18, "bold")
)

heading.pack(
    pady=30
)


# -----------------------------------------
# Comparison table
# -----------------------------------------

table_frame = tk.Frame(
    comparison_frame
)

table_frame.pack(
    pady=10
)


labels = [
    "Non-optimized Instructions",
    "Optimized Instructions",
    "Instructions Eliminated",
    "Instruction Reduction"
]


non_optimized_label = tk.Label(
    table_frame,
    text="-",
    font=("Arial", 16, "bold"),
    width=12
)

optimized_label = tk.Label(
    table_frame,
    text="-",
    font=("Arial", 16, "bold"),
    width=12
)

removed_label = tk.Label(
    table_frame,
    text="-",
    font=("Arial", 16, "bold"),
    width=12
)

efficiency_label = tk.Label(
    table_frame,
    text="-",
    font=("Arial", 16, "bold"),
    width=12
)


value_labels = [
    non_optimized_label,
    optimized_label,
    removed_label,
    efficiency_label
]


for i in range(4):

    tk.Label(
        table_frame,
        text=labels[i],
        font=("Arial", 13),
        width=30,
        anchor="w"
    ).grid(
        row=i,
        column=0,
        padx=20,
        pady=12
    )

    value_labels[i].grid(
        row=i,
        column=1,
        padx=20,
        pady=12
    )


# ============================================================
# SYNTAX TREE VISUALIZATION
# ============================================================

def parse_tree_text(tree_text):

    """
    Converts the text tree produced by compiler.py
    into a simple Node-like structure for drawing.
    """

    lines = tree_text.splitlines()

    if not lines:
        return None

    root_node = {
        "value": lines[0].strip(),
        "children": []
    }

    stack = [
        (-1, root_node)
    ]

    for line in lines[1:]:

        if not line.strip():
            continue

        # Find indentation
        stripped = line.lstrip()

        indentation = len(line) - len(stripped)

        # Remove L--- / R---
        if stripped.startswith("L--- "):
            value = stripped[5:]
        elif stripped.startswith("R--- "):
            value = stripped[5:]
        else:
            value = stripped

        node = {
            "value": value,
            "children": []
        }

        level = indentation // 4

        while stack and stack[-1][0] >= level:
            stack.pop()

        parent = stack[-1][1]

        parent["children"].append(node)

        stack.append(
            (level, node)
        )

    return root_node


def get_tree_size(node):

    """
    Calculates how many leaves and levels
    the tree contains.
    """

    if not node["children"]:
        return 1, 1

    leaf_count = 0
    max_depth = 0

    for child in node["children"]:

        leaves, depth = get_tree_size(child)

        leaf_count += leaves
        max_depth = max(
            max_depth,
            depth
        )

    return leaf_count, max_depth + 1


def draw_syntax_tree_from_text(tree_text):

    tree_canvas.delete("all")

    tree = parse_tree_text(tree_text)

    if tree is None:
        return

    leaves, depth = get_tree_size(tree)

    # -----------------------------------------
    # Dynamic spacing
    # -----------------------------------------

    horizontal_spacing = 85
    vertical_spacing = 75

    canvas_width = max(
        1000,
        leaves * horizontal_spacing
    )

    canvas_height = max(
        500,
        depth * vertical_spacing + 100
    )

    tree_canvas.config(
        scrollregion=(
            0,
            0,
            canvas_width,
            canvas_height
        )
    )

    # -----------------------------------------
    # Find node positions
    # -----------------------------------------

    positions = {}

    current_x = [60]

    def assign_positions(node, level=0):

        if not node["children"]:

            x = current_x[0]

            current_x[0] += horizontal_spacing

        else:

            child_positions = []

            for child in node["children"]:

                assign_positions(
                    child,
                    level + 1
                )

                child_positions.append(
                    positions[id(child)][0]
                )

            x = sum(child_positions) / len(
                child_positions
            )

        y = 60 + level * vertical_spacing

        positions[id(node)] = (
            x,
            y
        )

    assign_positions(tree)

    # Center tree
    if positions:

        min_x = min(
            x for x, y in positions.values()
        )

        max_x = max(
            x for x, y in positions.values()
        )

        tree_width = max_x - min_x

        shift = (
            canvas_width - tree_width
        ) / 2 - min_x

        positions = {
            key: (
                x + shift,
                y
            )
            for key, (x, y)
            in positions.items()
        }

    # -----------------------------------------
    # Draw connections first
    # -----------------------------------------

    def draw_connections(node):

        x1, y1 = positions[id(node)]

        for child in node["children"]:

            x2, y2 = positions[id(child)]

            # Start just below parent
            start_y = y1 + 25

            # End just above child
            end_y = y2 - 25

            tree_canvas.create_line(
                x1,
                start_y,
                x2,
                end_y,
                fill="#555555",
                width=2
            )

            draw_connections(child)

    draw_connections(tree)

    # -----------------------------------------
    # Draw nodes
    # -----------------------------------------

    def draw_nodes(node):

        x, y = positions[id(node)]

        value = node["value"]

        # Operator nodes
        if value in [
            "=",
            "+",
            "-",
            "*",
            "/",
            "^"
        ]:

            fill_color = "#DCEBFF"
            outline_color = "#4A78A8"

        # Number nodes
        elif value.replace(".", "", 1).isdigit():

            fill_color = "#E5F5E5"
            outline_color = "#4D8A4D"

        # Variable nodes
        else:

            fill_color = "#FFF0D5"
            outline_color = "#B07A28"

        # Calculate node width
        width = max(
            40,
            len(value) * 7 + 18
        )

        height = 32

        # Rounded-looking rectangle
        tree_canvas.create_rectangle(
            x - width / 2,
            y - height / 2,
            x + width / 2,
            y + height / 2,
            fill=fill_color,
            outline=outline_color,
            width=2
        )

        tree_canvas.create_text(
            x,
            y,
            text=value,
            font=("Consolas", 9, "bold"),
            fill="#222222"
        )

        for child in node["children"]:
            draw_nodes(child)

    draw_nodes(tree)

    # -----------------------------------------
    # Tree title
    # -----------------------------------------

    tree_canvas.create_text(
        canvas_width / 2,
        20,
        text="Abstract Syntax Tree",
        font=("Arial", 14, "bold"),
        fill="#333333"
    )


# ============================================================
# FOOTER
# ============================================================

footer = tk.Label(
    root,
    text="Compiler Design Project | Intermediate Code Generation",
    font=("Arial", 9)
)

footer.pack(
    pady=5
)


# ============================================================
# START APPLICATION
# ============================================================

root.mainloop()