mod tests;
use dep::std;

// btypeL 0->null, 1->block, 2->spike.
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
    spike_width_half: u64,
    spike_height_half: u64
}

fn is_valid_jump(action_y: u64, ground_y: u64, object_y: u64, HEIGHT_THRESHOLD: u64, config: Config) -> bool {
    (action_y + config.player_height_half > ground_y - HEIGHT_THRESHOLD & action_y + config.player_height_half < ground_y + HEIGHT_THRESHOLD) |
    (action_y + config.player_height_half > object_y - HEIGHT_THRESHOLD & action_y + config.player_height_half < object_y + HEIGHT_THRESHOLD)
}

fn main(
    objects: pub [Block; 50],
    actions: [Action; 50],
    config: Config
) {
    std::println(objects);
    std::println(actions);

    // Constants
    let MAX_OBJECTS = 50;
    let MAX_ACTIONS = 50;

    let ACTION_THRESHOLD = 300; // the length of jump.
    let HEIGHT_THRESHOLD = 40; // admit the player is not cheating if the height difference is less than this value.

    let ground_y = config.height - config.bufferHeight;

    let mut is_clear = true;
    let mut is_cheating = false;

    let mut last_landed_y = ground_y;
    let mut last_landed_x = 0;
    let mut last_landed_block_id = 0;
    // let mut last_landed_time = 0;
    // let mut last_action_type = 0; // 0: on ground, 1: jump, 2: fall

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

            let mut action_x = 0;
            let mut action_y = 0;
            let mut action_type = 0; // 0: null, 1: jump, 2: fall
            
            // loop for players action.
            // get the closest action to the object.

            let mut idx = 0; // idx == closest action index.
            let mut closest_action_distance = 9999999;

            for j in 0..MAX_ACTIONS {
                action_x = actions[j].x;
                if action_x < object_x {
                    let distance = object_x - action_x;
                    if distance < closest_action_distance {
                        closest_action_distance = distance;
                        idx = j;
                    }
                }
            }

            std::println("check last landed > actions.x");
            std::println(last_landed_x);
            std::println(actions[idx].x);

            // check if the last action is closer than last_landed_x
            if (last_landed_x > actions[idx].x) {
                action_x = objects[last_landed_block_id].x + config.block_width_half + config.player_width_half; // fall from the edge of the block.
                action_y = last_landed_y;
                action_type = 2;
            } else {
                action_x = actions[idx].x;
                action_y = actions[idx].y;
                action_type = actions[idx].atype;
            }

            let mut length = 0;
            let mut length_right = 0;

            if (object_x > action_x + config.block_width_half + config.player_width_half) { // check this to ensure the length>0.
                if (objects[i].btype == 1) {
                    length = object_x - action_x - config.block_width_half - config.player_width_half; // check the collision on the left side.
                    length_right = object_x - action_x + config.block_width_half + config.player_width_half;
                } else if (objects[i].btype == 2) {
                    length = object_x - action_x - config.spike_width_half - config.player_width_half; // check the collision on the left side.
                    length_right = object_x - action_x + config.spike_width_half + config.player_width_half; // check the collision on the right side.
                }
            } else {
                length = 0; // check the collision on the right side.
                length_right = object_x - action_x + config.spike_width_half + config.player_width_half;
            }

            // let length = object_x - actions[idx].x - config.block_width_half - config.player_width_half; // check the collision on the left side.
            if length > ACTION_THRESHOLD {
                // the closest action is too far.
                std::println("The closest action is too far.");
                std::println(length);
                std::println(action_x);
            } else {
                std::print("The closest action is: ");
                std::println(action_x);
                std::println(action_y);
                std::print("The closest action type is: ");
                std::println(action_type);

                // let length = object_x - actions[idx].x - config.block_width_half - config.player_width_half; // check the collision on the left side.

                // if (action_y > ground_y - HEIGHT_THRESHOLD & action_y < ground_y + HEIGHT_THRESHOLD) {
                //     std::println("the player jumped from the ground.");
                //     // is_alive = true;
                // } else if (action_y > ground_y - config.block_height_half - HEIGHT_THRESHOLD & action_y < ground_y - config.block_height_half + HEIGHT_THRESHOLD) {
                //     std::println("the player jumped from the block.");
                //     // is_alive = true;
                // } else {
                //     std::println("the player jumped from the air!!!!!!!");
                //     std::println(action_y);
                //     is_cheating = true;
                // }

                // if (action_y > config.height) {
                //     std::println("player is below the ground.");
                //     is_alive = false;
                // }

                // Find the object (if any) that the player is jumping from
                let mut jump_object_y = ground_y;

                for current_object_index in 0..i+1 {
                    // let curr_object_x = objects[current_object_index].x + config.preparation_width;
                    // if ((curr_object_x <= action_x + config.block_width_half + config.player_width_half) & (objects[current_object_index].btype == 1)) {
                    jump_object_y = config.height - objects[current_object_index].y - config.bufferHeight - config.block_height_half;
                    let is_tmp = is_valid_jump(action_y, ground_y, jump_object_y, HEIGHT_THRESHOLD, config);
                    std::println(is_tmp);
                    // }
                    // if ((curr_object_x <= action_x) & (objects[current_object_index].btype == 1)) {
                    //     jump_object_y = config.height - objects[current_object_index].y - config.bufferHeight + config.block_height_half;
                    // }
                }

                if !is_valid_jump(action_y, ground_y, jump_object_y, HEIGHT_THRESHOLD, config) {
                    std::println("The player is cheating!!!!!!!!!!!!!!");
                    std::print("action_y_bottom: ");
                    std::println(action_y + config.player_height_half);
                    std::print("ground_y: ");
                    std::println(ground_y);
                    std::print("jump_object_y: ");
                    std::println(jump_object_y);
                    is_cheating = true;
                }

                let player_y_0 = action_y;
                let mut player_y_left = 0;
                let mut player_y_right = 0;
                // let length_right = object_x - actions[idx].x + config.block_width_half + config.player_width_half; // check the collision on the right side. (where block_width_half == spike_width_half)
                let t = length * 100 / config.speed_x; // multiply by 100 to avoid float.
                let t_right = length_right * 100 / config.speed_x; // multiply by 100 to avoid float.
                // std::println(config.speed_y * t / 100);

                // divide by 100(^2) to reset to the original scale.
                // p_y = p_y_0 + g * t^2 / 2 - v_y * t (cuz top-y==0, bottom-y==max).
                // if p_y < 0, the player is outside of the screen. 

                if (action_type == 1) {
                    if (player_y_0 + config.gravity_y * t * t / (10000 * 2) < (config.speed_y * t / 100)) {
                        std::println("player is outside on the right");
                        player_y_left = 0;
                    } else {
                        player_y_left = player_y_0 + config.gravity_y * t * t / (10000 * 2) - (config.speed_y * t / 100);
                    }

                    if (player_y_0 + config.gravity_y * t_right * t_right / (10000 * 2) < (config.speed_y * t_right / 100)) {
                        std::println("player is outside on the right");
                        player_y_right = 0;
                    } else {
                        player_y_right = player_y_0 + config.gravity_y * t_right * t_right / (10000 * 2) - (config.speed_y * t_right / 100);
                    }
                } else if (action_type == 2) {
                    player_y_left = player_y_0 + config.gravity_y * t * t / (10000 * 2);
                    player_y_right = player_y_0 + config.gravity_y * t_right * t_right / (10000 * 2);
                } else {
                    player_y_left = player_y_0;
                    player_y_right = player_y_0;
                }
                

                std::print("length: ");
                std::println(length);
                std::print("t: ");
                std::println(t);
                std::print("SPEED_Y: ");
                std::println(config.speed_y);
                std::print("Gravity: ");
                std::println(config.gravity_y);
                std::print("object_y: ");
                std::println(object_y);
                std::print("player_y_left: ");
                std::println(player_y_left);
                std::print("length_right: ");
                std::println(length_right);
                std::print("t_right: ");
                std::println(t_right);
                std::print("player_y_right: ");
                std::println(player_y_right);

                std::print("player_y_left + config.player_height_half: ");
                std::println(player_y_left + config.player_height_half);
                std::print("object_y - config.block_height_half: ");
                std::println(object_y - config.block_height_half);
                std::print("player_y_right + config.player_height_half: ");
                std::println(player_y_right + config.player_height_half);


                // check if the player's bottom-right is above the object's top-left.
                // check if the player's top-right is below the object's bottom-left as well.(WIP)

                // if the object's type is block -> check the left side of the object.
                // if the object's type is spike -> check the both side of the object.

                if (objects[i].btype == 1) {
                    std::println("The object is a block.");
                    if (player_y_left + config.player_height_half >= object_y - config.block_height_half) {
                        std::println("Player is below the object.");
                        is_alive = false;
                    } else if (player_y_right + config.player_height_half >= object_y - config.block_height_half) {
                        std::println("Player is landed on the block");
                        last_landed_y = object_y - config.block_height_half - config.player_height_half;
                        last_landed_x = object_x - config.block_width_half; // the left side of the block.
                        last_landed_block_id = i;
                        // last_landed_time = 0;
                        is_alive = true;
                    }
                }
                
                if (player_y_left + config.player_height_half >= object_y - config.block_height_half) {
                    std::println("Player is below the object.");
                    is_alive = false;
                } else if (objects[i].btype == 2) {
                    std::println("The object is a spike.");
                    if (player_y_right + config.player_height_half <= object_y + config.spike_height_half) {
                        std::println("Player is above the spike.");
                        is_alive = true;
                    } else {
                        std::println("Player hit the spike.");
                        is_alive = false;
                    }
                } else {
                    is_alive = true;
                }
            }

            if is_alive {
                std::println("Player is alive.");
            } else {
                std::println("###################");
                std::println("Player is dead.");
                std::println("###################");
                is_clear = false;
            }
        }
    }

    std::println(is_clear);
    std::println(is_cheating);

    assert(is_clear & !is_cheating, "The player is dead.");
}