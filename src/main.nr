mod tests;
use dep::std;

// btypeL 0->null, 1->block, 2->needle.
struct Block {
    x: u64,
    y: u64,
    btype: u8
}

// atype: 0->null, 1->jump, ...
struct Action {
    x: u64,
    y: u64,
    atype: u8
}

struct Config {
    height: u64,
    bufferHeight: u64,
    gravity_y: u64,
    speed_x: u64,
    speed_y: u64,
    preparation_width: u64
}

fn main(
    objects: pub [Block; 3],
    actions: [Action; 8],
    config: Config
) {
    std::println(objects);
    std::println(actions);

    // Constants
    let MAX_OBJECTS = 3;
    let MAX_ACTIONS = 8;

    let ACTION_THRESHOLD = 300; // the length of jump.

    let mut is_clear = true;

    for i in 0..MAX_OBJECTS {
        std::println(objects[i]);

        // loop for possibilities of death.
        if objects[i].btype == 0 {
            std::println("There is no more objects."); // skip like this cuz can't use break.
        } else {
            let mut is_alive = false;
            std::println("There is an object.");
            // TODO: Implement the logic.

            let object_x = objects[i].x + config.preparation_width;
            let object_y = config.height - objects[i].y - config.bufferHeight;
            
            // loop for players action.
            for j in 0..MAX_ACTIONS {
                if (actions[j].x >= object_x) {
                    // skip
                    std::println("this action is not relevant.")
                } else {
                    let length = object_x- actions[j].x;
                    if (length > ACTION_THRESHOLD) {
                        // skip
                        std::println("this action is not relevant.")
                    } else {
                        std::println(actions[j]);
                        // check if the y-coordinate of the player is valid or not.
                        if (actions[j].y > config.height) {
                            std::println("player is outside");
                            is_alive = false;
                        }

                        // let player_x_0 = actions[j].x;
                        let player_y_0 = actions[j].y;
                        let mut player_y = 0;
                        let t = length * 100 / config.speed_x;
                        std::println(config.speed_y * t / 100);
                        if (player_y_0 + config.gravity_y * t * t / (10000 * 2) < (config.speed_y * t / 100)) {
                            std::println("player is outside");
                            player_y = 0;
                        } else {
                            player_y = player_y_0 + config.gravity_y * t * t / (10000 * 2) - (config.speed_y * t / 100);
                        }
                        std::print("t: ");
                        std::println(t);
                        std::print("SPEED_Y: ");
                        std::println(config.speed_y);
                        std::print("Gravity: ");
                        std::println(config.gravity_y);
                        std::print("player_y: ");
                        std::println(player_y);
                        std::print("object_y: ");
                        std::println(object_y);

                        if (player_y <= object_y) {
                            is_alive = true;
                        } else {
                            is_alive = false;
                        }
                    }
                }
            }
            if is_alive {
                std::println("Player is alive.");
            } else {
                std::println("Player is dead.");
                is_clear = false;
            }
        }
    }

    assert(is_clear, "The player is dead.");
}