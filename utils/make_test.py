import argparse
import json
import toml

MAX_OBJETCS = 3
MAX_ACTIONS = 8

def read_json(file_path):
    with open(file_path, 'r') as f:
        return json.load(f)

def read_toml(file_path):
    with open(file_path, 'r') as f:
        return toml.load(f)

def convert_btype(s):
    if s == "block":
        return 1
    elif s == "needle":
        return 2
    else:
        return 0

def generate_noir_test(config, actions, objects, test_name):
    test_case = f"""
#[test]
fn {test_name}() {{
    let objects = [
        {', '.join(f"Block {{ x: {obj['x']}, y: {obj['y']}, btype: {convert_btype(obj['btype'])} }}" for obj in objects)},
        {', '.join(f"Block {{ x: 0, y: 0, btype: 0 }}" for _ in range(MAX_OBJETCS - len(objects)))}
    ];
    let actions = [
        {', '.join(f"Action {{ x: {int(action['x'])}, y: {int(action['y'])}, atype: {0 if action['action'] == 'jump' else 1} }}" for action in actions)},
        {', '.join(f"Action {{ x: 0, y: 0, atype: 0 }}" for _ in range(MAX_ACTIONS - len(actions)))}
    ];
    let config = Config {{
        height: {config['height']},
        bufferHeight: {config['bufferHeight']},
    }};
    
    main(objects, actions, config);
}}
"""
    return test_case

def main():
    parser = argparse.ArgumentParser(description='Generate Noir test cases from input files.')
    parser.add_argument('-c', '--config', required=True, help='Path to the config file')
    parser.add_argument('-a', '--actions', required=True, help='Path to the actions file')
    parser.add_argument('-o', '--objects', required=True, help='Path to the objects file')
    parser.add_argument('-n', '--test-name', default='test_generated', help='Name for the generated test function')
    args = parser.parse_args()

    # Read input files
    config = read_toml(args.config)
    actions = read_json(args.actions)
    objects = read_json(args.objects)

    # Generate Noir test case
    noir_test = generate_noir_test(config, actions, objects, args.test_name)

    # Print the generated test case
    print(noir_test)

if __name__ == "__main__":
    main()