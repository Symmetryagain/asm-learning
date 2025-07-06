import numpy as np
import os


def main():
    os.makedirs("files", exist_ok=True)

    input_path = "py/files/in.txt"
    output_path = "py/files/out.txt"

    try:
        with open(input_path, 'r') as f:
            dimensions = f.readline().split()
            if len(dimensions) != 3:
                raise ValueError(
                    "Invalid header format. Expected 3 dimensions")

            rowsA = int(dimensions[0])
            colsA = int(dimensions[1])
            colsB = int(dimensions[2])

            A = np.zeros((rowsA, colsA))
            for i in range(rowsA):
                row = f.readline().split()
                if len(row) != colsA:
                    raise ValueError(
                        f"Row {i+1} of matrix A has incorrect length")
                A[i] = list(map(float, row))

            B = np.zeros((colsA, colsB))
            for i in range(colsA):
                row = f.readline().split()
                if len(row) != colsB:
                    raise ValueError(
                        f"Row {i+1} of matrix B has incorrect length")
                B[i] = list(map(float, row))

        C = np.dot(A, B)

        with open(output_path, 'w') as f:
            for row in C:
                formatted_row = []
                for x in row:
                    if x.is_integer():
                        formatted_row.append(f"{int(x)}")
                    else:
                        s = f"{x:.6f}"
                        if '.' in s:
                            s = s.rstrip('0').rstrip('.')
                        formatted_row.append(s)
                f.write(" ".join(formatted_row) + "\n")

        print("Matrix multiplication completed using NumPy.")
        print(f"Result saved to {output_path}")

    except FileNotFoundError:
        print(f"Error: Input file not found at {input_path}")
    except Exception as e:
        print(f"Error: {str(e)}")


if __name__ == "__main__":
    main()
