use crate::main;
use crate::Block;

#[test]
fn test_main() {

    // 
    let objects = [
        Block { x: 200, y: 0, btype: 1 },
        Block { x: 0, y: 0, btype: 0 },
        Block { x: 0, y: 0, btype: 0 },
    ];
    let actions = [
        141, 193, 318, 0, 0, 0, 0, 0
    ];
    
    main(objects, actions);

    // Uncomment to make test fail
    // main(1, 1);
}
