use crate::main;
use crate::Block;
use crate::Action;
use crate::Config;

#[test]
fn test_clear_1() {

    // 
    let objects = [
        Block { x: 200, y: 0, btype: 2 },
        Block { x: 0, y: 0, btype: 0 },
        Block { x: 0, y: 0, btype: 0 },
    ];
    let actions = [
        Action { x: 338, y: 319, atype: 0 }, Action { x: 1312, y: 319, atype: 0 },
        Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }
    ];
    let config = Config{
        height: 390,
        bufferHeight: 70,
        gravity_y: 2000,
        speed_x: 340,
        speed_y: 700,
        preparation_width: 1200,
        player_width_half: 25,
        player_height_half: 21,
        block_width_half: 25,
        block_height_half: 28,
        spike_width_half: 25,
        spike_height_half: 20,
    };
    
    main(objects, actions, config);

    // Uncomment to make test fail
    // main(1, 1);
}

#[test]
fn test_clear_2() {
    let objects = [
        Block { x: 200, y: 0, btype: 2 },
        Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }
    ];
    let actions = [
        Action { x: 303, y: 319, atype: 0 }, Action { x: 1233, y: 319, atype: 0 },
        Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }
    ];
    let config = Config{
        height: 390,
        bufferHeight: 70,
        gravity_y: 2000,
        speed_x: 340,
        speed_y: 700,
        preparation_width: 1200,
        player_width_half: 25,
        player_height_half: 21,
        block_width_half: 25,
        block_height_half: 28,
        spike_width_half: 25,
        spike_height_half: 20,
    };
    
    main(objects, actions, config);
}


#[test(should_fail)]
fn test_dead_1() {
    let objects = [
        Block { x: 200, y: 0, btype: 1 },
        Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }
    ];
    let actions = [
        Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }
    ];
    let config = Config{
        height: 390,
        bufferHeight: 70,
        gravity_y: 2000,
        speed_x: 340,
        speed_y: 700,
        preparation_width: 1200,
        player_width_half: 25,
        player_height_half: 21,
        block_width_half: 25,
        block_height_half: 28,
        spike_width_half: 25,
        spike_height_half: 20,
    };
    
    main(objects, actions, config);
}

#[test(should_fail)]
fn test_dead_2() {
    let objects = [
        Block { x: 200, y: 0, btype: 2 },
        Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }
    ];
    let actions = [
        Action { x: 383, y: 319, atype: 0 }, Action { x: 1199, y: 319, atype: 0 },
        Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }
    ];
    let config = Config{
        height: 390,
        bufferHeight: 70,
        gravity_y: 2000,
        speed_x: 340,
        speed_y: 700,
        preparation_width: 1200,
        player_width_half: 25,
        player_height_half: 21,
        block_width_half: 25,
        block_height_half: 25,
        spike_width_half: 25,
        spike_height_half: 20,
    };
    
    main(objects, actions, config);
}