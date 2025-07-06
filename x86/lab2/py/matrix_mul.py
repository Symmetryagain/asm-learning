def read_matrix(file, rows, cols):
    matrix = []
    for _ in range(rows):
        line = file.readline().split()
        if len(line) != cols:
            raise ValueError(f"Expected {cols} values, got {len(line)}")
        matrix.append([float(x) for x in line])
    return matrix


def matrix_multiply(A, B):
    rowsA = len(A)
    colsA = len(A[0])
    colsB = len(B[0])
    C = [[0.0] * colsB for _ in range(rowsA)]
    for i in range(rowsA):
        for k in range(colsA):
            a_val = A[i][k]
            for j in range(colsB):
                C[i][j] += a_val * B[k][j]
    return C


def main():
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
            A = read_matrix(f, rowsA, colsA)
            B = read_matrix(f, colsA, colsB)
        C = matrix_multiply(A, B)
        with open(output_path, 'w') as f:
            for row in C:
                f.write(" ".join(f"{x:.6f}" for x in row) + "\n")
        print(f"Matrix multiplication completed. Result saved to {
              output_path}")
    except FileNotFoundError:
        print(f"Error: Input file not found at {input_path}")
    except Exception as e:
        print(f"Error: {str(e)}")


if __name__ == "__main__":
    main()
