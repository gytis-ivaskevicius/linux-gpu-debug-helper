`{{Related articles start}}`{=mediawiki} `{{Related|Steam}}`{=mediawiki} `{{Related|Gamepad}}`{=mediawiki}
`{{Related|Gaming}}`{=mediawiki} `{{Related articles end}}`{=mediawiki}

Steam Input Configurator is a powerful gamepad rebinding tool that is bundled with [Steam](Steam "wikilink").
[1](https://partner.steamgames.com/doc/features/steam_controller/concepts)

The configuration files are stored in `{{ic|~/.steam/steam/userdata/<USER_ID>/241100/remote/}}`{=mediawiki}

Steam Input Configurator (SIC) requires a controller to be connected for it to be accessible. Game specific
configurations can be accessed through the gamepad icon right of the *Install*/*Play* button. Desktop configurations can
be found in *Steam* \> *Settings* \> *Controller* \> *Desktop Layout*. Global bindings that are accessible everywhere by
holding the controller home button can also be found here under *Guide Button Chord Layout*.

## Basic rebinding {#basic_rebinding}

*View Layout* takes you to an overview where you can select the button you want to reconfigure and *Edit Layout* takes
you to this menu directly. Here you can select an input and bind it to any gamepad, keyboard, or mouse action. Various
system actions are also supported.

## Multiple commands in the same button {#multiple_commands_in_the_same_button}

By selecting the gear icon next to the binding, you can add more than one action into the same button. *Add sub command*
creates a command that will be pressed simultaneously with the parent command and *Add extra command* creates a separate
binding with its own settings and activation logic.

The topmost gear menu entry is used to set the activation logic. With this a single button can have multiple bindings
depending the button was pressed once, twice or with a long press. The details can be adjusted in the *Settings* menu
right below it.

## Layouts

In the main view of the configurator, selecting the top button with the layout name allows you to browse available
layouts.

-   *Recommended* contains layouts set by the developer or Valve
-   *Your Layouts* contains layouts that the user has saved. One of these is an auto-save that updates every time a
    change is made to the currently active layout, although it is not self-evident which one it is
-   *Templates* contains layouts that are available for any game. Valve provides some of these, but the user can create
    their own templates by exporting the currently active layout.
-   *Community Layouts* contains layouts that other users have shared for a given game.

Community layouts for non-steam games are defined by the game name. It is possible to browse layouts by changing the
name to match what you want to find. To browse steam game layouts, match the game name with a game store page ID.

## Gyro

Many games benefit from using gyro for more fine tuned aiming. It is recommended to use *Gyro To Mouse* as it\'s less
prone to errors than the old *As Mouse*. Depending on a game not having simultaneous mouse and controller support it
might be good to select the *Gyro To Joystick Camera*.

### Gyro calibration {#gyro_calibration}

To calibrate the gyro, first the Dots per 360° needs to be adjusted to be as accurate as possible. Take any button
binding and in the *Camera* input tab select *Turn Camera 360°*. Now inside the game stare at a fixated point while
pressing the *Turn Camera 360°* binding. If you do not return you to the point you started in, adjust the *Gyro Angles
to Mouse Pixels (Dots Per 360°)* in gyro settings until you do. This setting does not only apply to gyro, but also Flick
Stick and the previously used turn camera command.

Now adjust *Gyro ° Sensitivity* setting to match our desire.

### Common gyro configurations {#common_gyro_configurations}

It is common to use a trackpad or a joystick to do major movements while using gyro for fine-tuned movement. The
simplest is setting a trackpad *As Mouse* or a joystick with the *Joystick* setting and then setting gyro activation to
trackpad or joystick touch. *Flick Stick* is a more advanced method where the direction of the joystick determines the
facing direction, allowing for instant turns but limiting y-axis turning to gyro. When using Flick Stick, it is
reasonable to adjust the Vertical/Horizontal ratio to 35% and then increasing the sensitivity until it feels
comfortable.

## Action Sets and Layers {#action_sets_and_layers}

Sets and layers are convenient ways of including multiple control schemes in a single layout. They can be configured at
the bottom of the configuration menu. Layers are applied on top of the current set, which is useful for minor
adjustments. You might want the configuration to function slightly differently when aiming down sights or running. Sets
on the other hand start from scratch. A common usecase for this is to switch to a gamepad mode when in desktop so that
gamepad input is possible without adding the application as a non-steam game

Switching between these happens with a binding. Open your desired input button binding and in the *Action Sets* tab
select the action you want. Adjust the activator if you want the action to trigger on long press.

## Notes

Button Chord, Mode Shift and Action Layers essentially do the same thing but in different scopes.

[Category:Gaming](Category:Gaming "wikilink")
