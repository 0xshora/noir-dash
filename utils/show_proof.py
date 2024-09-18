import json
from typing import List, Dict

class G1ProofPoint:
    def __init__(self, x_0: int, x_1: int, y_0: int, y_1: int):
        self.x_0 = x_0
        self.x_1 = x_1
        self.y_0 = y_0
        self.y_1 = y_1

class Proof:
    def __init__(self):
        self.circuit_size: int = 0
        self.public_inputs_size: int = 0
        self.public_inputs_offset: int = 0
        self.w1: G1ProofPoint = None
        self.w2: G1ProofPoint = None
        self.w3: G1ProofPoint = None
        self.lookup_read_counts: G1ProofPoint = None
        self.lookup_read_tags: G1ProofPoint = None
        self.w4: G1ProofPoint = None
        self.lookup_inverses: G1ProofPoint = None
        self.z_perm: G1ProofPoint = None
        self.sumcheck_univariates: List[List[int]] = []
        self.sumcheck_evaluations: List[int] = []
        self.zm_cqs: List[G1ProofPoint] = []
        self.zm_cq: G1ProofPoint = None
        self.zm_pi: G1ProofPoint = None

def load_proof(file_path: str) -> Proof:
    with open(file_path, 'r') as f:
        proof_data = json.load(f)

    p = Proof()

    # メタデータ
    p.circuit_size = int(proof_data[0], 16)
    p.public_inputs_size = int(proof_data[1], 16)
    p.public_inputs_offset = int(proof_data[2], 16)

    # コミットメント
    p.w1 = G1ProofPoint(*[int(x, 16) for x in proof_data[3:7]])
    p.w2 = G1ProofPoint(*[int(x, 16) for x in proof_data[7:11]])
    p.w3 = G1ProofPoint(*[int(x, 16) for x in proof_data[11:15]])

    # Lookup / Permutation Helper コミットメント
    p.lookup_read_counts = G1ProofPoint(*[int(x, 16) for x in proof_data[15:19]])
    p.lookup_read_tags = G1ProofPoint(*[int(x, 16) for x in proof_data[19:23]])
    p.w4 = G1ProofPoint(*[int(x, 16) for x in proof_data[23:27]])
    p.lookup_inverses = G1ProofPoint(*[int(x, 16) for x in proof_data[27:31]])
    p.z_perm = G1ProofPoint(*[int(x, 16) for x in proof_data[31:35]])

    # Sumcheck univariates
    CONST_PROOF_SIZE_LOG_N = 7  # この値は実際の回路サイズに応じて調整する必要があります
    BATCHED_RELATION_PARTIAL_LENGTH = 7
    start = 35
    for _ in range(CONST_PROOF_SIZE_LOG_N):
        p.sumcheck_univariates.append([int(x, 16) for x in proof_data[start:start+BATCHED_RELATION_PARTIAL_LENGTH]])
        start += BATCHED_RELATION_PARTIAL_LENGTH

    # Sumcheck evaluations
    NUMBER_OF_ENTITIES = 7  # この値も実際の回路に応じて調整する必要があります
    p.sumcheck_evaluations = [int(x, 16) for x in proof_data[start:start+NUMBER_OF_ENTITIES]]
    start += NUMBER_OF_ENTITIES

    # Zero morph Commitments
    for _ in range(CONST_PROOF_SIZE_LOG_N):
        if len(proof_data[start:start+4]) == 4:
            p.zm_cqs.append(G1ProofPoint(*[int(x, 16) for x in proof_data[start:start+4]]))
        else:
            print(f"Warning: Insufficient data for G1ProofPoint at index {start}")
        start += 4

    if len(proof_data[start:start+4]) == 4:
        p.zm_cq = G1ProofPoint(*[int(x, 16) for x in proof_data[start:start+4]])
    else:
        print(f"Warning: Insufficient data for zm_cq at index {start}")
        p.zm_cq = None
    start += 4

    if len(proof_data[start:start+4]) == 4:
        p.zm_pi = G1ProofPoint(*[int(x, 16) for x in proof_data[start:start+4]])
    else:
        print(f"Warning: Insufficient data for zm_pi at index {start}")
        p.zm_pi = None

    return p

def print_proof(p: Proof):
    print(f"Circuit Size: {p.circuit_size}")
    print(f"Public Inputs Size: {p.public_inputs_size}")
    print(f"Public Inputs Offset: {p.public_inputs_offset}")
    print("\nCommitments:")
    print(f"W1: ({p.w1.x_0}, {p.w1.x_1}, {p.w1.y_0}, {p.w1.y_1})")
    print(f"W2: ({p.w2.x_0}, {p.w2.x_1}, {p.w2.y_0}, {p.w2.y_1})")
    print(f"W3: ({p.w3.x_0}, {p.w3.x_1}, {p.w3.y_0}, {p.w3.y_1})")
    print(f"Lookup Read Counts: ({p.lookup_read_counts.x_0}, {p.lookup_read_counts.x_1}, {p.lookup_read_counts.y_0}, {p.lookup_read_counts.y_1})")
    print(f"Lookup Read Tags: ({p.lookup_read_tags.x_0}, {p.lookup_read_tags.x_1}, {p.lookup_read_tags.y_0}, {p.lookup_read_tags.y_1})")
    print(f"W4: ({p.w4.x_0}, {p.w4.x_1}, {p.w4.y_0}, {p.w4.y_1})")
    print(f"Lookup Inverses: ({p.lookup_inverses.x_0}, {p.lookup_inverses.x_1}, {p.lookup_inverses.y_0}, {p.lookup_inverses.y_1})")
    print(f"Z Perm: ({p.z_perm.x_0}, {p.z_perm.x_1}, {p.z_perm.y_0}, {p.z_perm.y_1})")
    print("\nSumcheck Univariates:")
    for i, univariate in enumerate(p.sumcheck_univariates):
        print(f"  {i}: {univariate}")
    print("\nSumcheck Evaluations:")
    print(p.sumcheck_evaluations)
    print("\nZero Morph Commitments:")
    for i, zm_cq in enumerate(p.zm_cqs):
        print(f"  {i}: ({zm_cq.x_0}, {zm_cq.x_1}, {zm_cq.y_0}, {zm_cq.y_1})")
    if p.zm_cq:
        print(f"ZM CQ: ({p.zm_cq.x_0}, {p.zm_cq.x_1}, {p.zm_cq.y_0}, {p.zm_cq.y_1})")
    else:
        print("ZM CQ: None")
    if p.zm_pi:
        print(f"ZM PI: ({p.zm_pi.x_0}, {p.zm_pi.x_1}, {p.zm_pi.y_0}, {p.zm_pi.y_1})")
    else:
        print("ZM PI: None")

if __name__ == "__main__":
    proof = load_proof("./target/output/proof_fields.json")
    print_proof(proof)
