import json
from dataclasses import dataclass
from typing import List

@dataclass
class AffineG1:
    x: int
    y: int

@dataclass
class PlonkProof:
    A: AffineG1
    B: AffineG1
    C: AffineG1
    Z: AffineG1
    T1: AffineG1
    T2: AffineG1
    T3: AffineG1
    Wxi: AffineG1
    Wxiw: AffineG1
    eval_a: int
    eval_b: int
    eval_c: int
    eval_s1: int
    eval_s2: int
    eval_zw: int

def load_plonk_proof(file_path: str) -> PlonkProof:
    with open(file_path, 'r') as f:
        proof_data = json.load(f)

    # メタデータは無視します（PLONKの証明構造には直接含まれないため）

    # ワイヤーコミットメントを変換
    A = AffineG1(int(proof_data[3], 16), int(proof_data[4], 16))
    B = AffineG1(int(proof_data[7], 16), int(proof_data[8], 16))
    C = AffineG1(int(proof_data[11], 16), int(proof_data[12], 16))

    # パーミューテーション多項式のコミットメント
    Z = AffineG1(int(proof_data[31], 16), int(proof_data[32], 16))

    # T1, T2, T3はルックアップ関連のコミットメントから構成
    T1 = AffineG1(int(proof_data[15], 16), int(proof_data[16], 16))
    T2 = AffineG1(int(proof_data[19], 16), int(proof_data[20], 16))
    T3 = AffineG1(int(proof_data[23], 16), int(proof_data[24], 16))

    # Wxi, Wxiwはサムチェックとゼロモーフから構成
    start = 35 + 7 * 7 + 7  # サムチェックのデータをスキップ
    Wxi = AffineG1(int(proof_data[start], 16), int(proof_data[start+1], 16))
    Wxiw = AffineG1(int(proof_data[start+4], 16), int(proof_data[start+5], 16))

    # 評価値はサムチェック評価から取得
    eval_start = 35 + 7 * 7
    eval_a = int(proof_data[eval_start], 16)
    eval_b = int(proof_data[eval_start+1], 16)
    eval_c = int(proof_data[eval_start+2], 16)
    eval_s1 = int(proof_data[eval_start+3], 16)
    eval_s2 = int(proof_data[eval_start+4], 16)
    eval_zw = int(proof_data[eval_start+5], 16)

    return PlonkProof(A, B, C, Z, T1, T2, T3, Wxi, Wxiw, eval_a, eval_b, eval_c, eval_s1, eval_s2, eval_zw)

def print_plonk_proof(proof: PlonkProof):
    print("PLONK Proof:")
    print(f"A: ({proof.A.x}, {proof.A.y})")
    print(f"B: ({proof.B.x}, {proof.B.y})")
    print(f"C: ({proof.C.x}, {proof.C.y})")
    print(f"Z: ({proof.Z.x}, {proof.Z.y})")
    print(f"T1: ({proof.T1.x}, {proof.T1.y})")
    print(f"T2: ({proof.T2.x}, {proof.T2.y})")
    print(f"T3: ({proof.T3.x}, {proof.T3.y})")
    print(f"Wxi: ({proof.Wxi.x}, {proof.Wxi.y})")
    print(f"Wxiw: ({proof.Wxiw.x}, {proof.Wxiw.y})")
    print(f"eval_a: {proof.eval_a}")
    print(f"eval_b: {proof.eval_b}")
    print(f"eval_c: {proof.eval_c}")
    print(f"eval_s1: {proof.eval_s1}")
    print(f"eval_s2: {proof.eval_s2}")
    print(f"eval_zw: {proof.eval_zw}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python convert_proof.py <path_to_proof_fields.json>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    plonk_proof = load_plonk_proof(file_path)
    print_plonk_proof(plonk_proof)
