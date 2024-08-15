mod tests;
use dep::std;

struct Block {
    x: u64,
    y: u64,
    btype: u8
}

fn main(
    objects: pub [Block; 3],
    actions: [u64; 8]
) {
    std::println(objects);
    std::println(actions);

    // Constants
    let GRAVITY_Y = 0;
    let SPEED_X = 340;
    let MAX_OBJECTS = 3;

    let mut player_x = 0;
    let mut player_y = 0;
    let mut player_vel = 0;
    let mut player_acc = 0;

    let gravity_y = 0;
    let speed = 0;

    for i in 0..MAX_OBJECTS {
        std::println(objects[i]);
        if objects[i].btype == 0 {
            std::println("There is no more objects."); // can't use break.
        } else {
            std::println("There is an object.");
            // TODO: Implement the logic.
        }
    }
}