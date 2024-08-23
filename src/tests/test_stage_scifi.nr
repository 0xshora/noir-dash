use crate::main;
use crate::Block;
use crate::Action;
use crate::Config;

#[test]
fn test_clear_1() {
    let objects = [
        Block { x: 600, y: 0, btype: 1 }, Block { x: 920, y: 0, btype: 2 }, Block { x: 980, y: 0, btype: 1 }, Block { x: 1460, y: 0, btype: 2 }, Block { x: 1790, y: 0, btype: 2 }, Block { x: 1840, y: 0, btype: 1 }, Block { x: 2140, y: 30, btype: 1 }, Block { x: 2190, y: 0, btype: 2 }, Block { x: 2580, y: 0, btype: 1 }, Block { x: 2910, y: 50, btype: 1 }, Block { x: 2960, y: 0, btype: 2 }, Block { x: 3100, y: 0, btype: 2 }, Block { x: 3100, y: 100, btype: 1 }, Block { x: 3480, y: 0, btype: 1 }, Block { x: 3620, y: 0, btype: 2 }, Block { x: 3670, y: 0, btype: 2 }, Block { x: 4140, y: 0, btype: 1 }, Block { x: 4260, y: 0, btype: 2 }, Block { x: 4660, y: 0, btype: 1 }, Block { x: 4780, y: 0, btype: 2 }, Block { x: 4920, y: 0, btype: 1 }, Block { x: 5040, y: 0, btype: 2 },
        Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }, Block { x: 0, y: 0, btype: 0 }
    ];
    let actions = [
        Action { x: 315, y: 319, atype: 1 }, Action { x: 859, y: 319, atype: 1 }, Action { x: 1664, y: 319, atype: 1 }, Action { x: 2015, y: 319, atype: 1 }, Action { x: 2542, y: 319, atype: 1 }, Action { x: 2859, y: 319, atype: 1 }, Action { x: 3171, y: 319, atype: 1 }, Action { x: 3369, y: 241, atype: 1 }, Action { x: 3658, y: 319, atype: 1 }, Action { x: 3930, y: 319, atype: 1 }, Action { x: 4117, y: 221, atype: 1 }, Action { x: 4508, y: 319, atype: 1 }, Action { x: 4718, y: 269, atype: 1 }, Action { x: 5120, y: 319, atype: 1 }, Action { x: 5353, y: 271, atype: 1 }, Action { x: 5681, y: 319, atype: 1 }, Action { x: 5891, y: 269, atype: 1 }, Action { x: 6129, y: 271, atype: 1 },
        Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }, Action { x: 0, y: 0, atype: 0 }
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
