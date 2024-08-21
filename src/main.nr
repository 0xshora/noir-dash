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
    height: u64, // the height of the screen.
    bufferHeight: u64, // the height from the bottom of the screen to the bottom of the ground.
    gravity_y: u64,
    speed_x: u64,
    speed_y: u64,
    preparation_width: u64,
    player_width_half: u64,
    player_height_half: u64,
    block_width_half: u64,
    block_height_half: u64,
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
    let HEIGHT_THRESHOLD = 40; // admit the player is not cheating if the height difference is less than this value.

    let ground_y = config.height - config.bufferHeight;

    let mut is_clear = true;
    let mut is_cheating = false;

    for i in 0..MAX_OBJECTS {
        std::println(objects[i]);

        // loop for possibilities of death.
        if objects[i].btype == 0 {
            std::println("There is no more objects."); // skip like this cuz can't use break.
        } else {
            let mut is_alive = false;
            std::println("There is an object.");

            let object_x = objects[i].x + config.preparation_width;
            let object_y = config.height - objects[i].y - config.bufferHeight;
            
            // loop for players action.
            // get the closest action to the object.

            let mut idx = 0; // idx == closest action index.
            let mut closest_action_distance = 999999;

            for j in 0..MAX_ACTIONS {
                let action_x = actions[j].x + config.block_width_half + config.player_width_half;
                if action_x < object_x {
                    let distance = object_x - action_x;
                    if distance < closest_action_distance {
                        closest_action_distance = distance;
                        idx = j;
                    }
                }
            }

            let length = object_x - actions[idx].x - config.block_width_half - config.player_width_half; // check the collision on the left side.
            if length > ACTION_THRESHOLD {
                // the closest action is too far.
                std::println("The closest action is too far.");
            } else {
                std::print("The closest action is: ");
                std::println(actions[idx]);

                let length = object_x - actions[idx].x - config.block_width_half - config.player_width_half; // check the collision on the left side.

                if (actions[idx].y > ground_y - HEIGHT_THRESHOLD & actions[idx].y < ground_y + HEIGHT_THRESHOLD) {
                    std::println("the player jumped from the ground.");
                    // is_alive = true;
                } else if (actions[idx].y > ground_y - config.block_height_half - HEIGHT_THRESHOLD & actions[idx].y < ground_y - config.block_height_half + HEIGHT_THRESHOLD) {
                    std::println("the player jumped from the block.");
                    // is_alive = true;
                } else {
                    std::println("the player jumped from the air.");
                    is_cheating = true;
                }

                if (actions[idx].y > config.height) {
                    std::println("player is below the ground.");
                    is_alive = false;
                }


                let player_y_0 = actions[idx].y;
                let mut player_y = 0;
                let t = length * 100 / config.speed_x; // multiply by 100 to avoid float.
                // std::println(config.speed_y * t / 100);

                // divide by 100(^2) to reset to the original scale.
                // p_y = p_y_0 + g * t^2 / 2 - v_y * t (cuz top-y==0, bottom-y==max).
                // if p_y < 0, the player is outside of the screen. 
                if (player_y_0 + config.gravity_y * t * t / (10000 * 2) < (config.speed_y * t / 100)) {
                    std::println("player is outside");
                    player_y = 0;
                } else {
                    player_y = player_y_0 + config.gravity_y * t * t / (10000 * 2) - (config.speed_y * t / 100);
                }

                std::print("length: ");
                std::println(length);
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

                std::print("player_y + config.player_height_half: ");
                std::println(player_y + config.player_height_half);
                std::print("object_y - config.block_height_half: ");
                std::println(object_y - config.block_height_half);

                // check if the player's bottom-right is above the object's top-left.
                // check if the player's top-right is below the object's bottom-left as well.(WIP)
                if (player_y + config.player_height_half <= object_y - config.block_height_half) {
                    std::println("Player is above the object.");
                    is_alive = true;
                } else {
                    std::println("Player is below the object.");
                    is_alive = false;
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

    assert(is_clear & !is_cheating, "The player is dead.");
}