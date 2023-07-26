use super::long_string::LongString;
use array::{ArrayTrait};
use core::traits::{Into};

// Magical T1s
const Warlock: u8 = 1;
const Typhon: u8 = 2;
const Jiangshi: u8 = 3;
const Anansi: u8 = 4;
const Basilisk: u8 = 5;

// Magical T2s
const Gorgon: u8 = 6;
const Kitsune: u8 = 7;
const Lich: u8 = 8;
const Chimera: u8 = 9;
const Wendigo: u8 = 10;

// Magical T3s
const Rakshasa: u8 = 11;
const Werewolf: u8 = 12;
const Banshee: u8 = 13;
const Draugr: u8 = 14;
const Vampire: u8 = 15;

// Magical T4s
const Goblin: u8 = 16;
const Ghoul: u8 = 17;
const Wraith: u8 = 18;
const Sprite: u8 = 19;
const Kappa: u8 = 20;

// Magical T5s
const Fairy: u8 = 21;
const Leprechaun: u8 = 22;
const Kelpie: u8 = 23;
const Pixie: u8 = 24;
const Gnome: u8 = 25;

// Hunter T1s
const Griffin: u8 = 26;
const Manticore: u8 = 27;
const Phoenix: u8 = 28;
const Dragon: u8 = 29;
const Minotaur: u8 = 30;

// Hunter T2s
const Qilin: u8 = 31;
const Ammit: u8 = 32;
const Nue: u8 = 33;
const Skinwalker: u8 = 34;
const Chupacabra: u8 = 35;

// Hunter T3s
const Weretiger: u8 = 36;
const Wyvern: u8 = 37;
const Roc: u8 = 38;
const Harpy: u8 = 39;
const Pegasus: u8 = 40;

// Hunter T4s
const Hippogriff: u8 = 41;
const Fenrir: u8 = 42;
const Jaguar: u8 = 43;
const Satori: u8 = 44;
const DireWolf: u8 = 45;

// Hunter T5s
const Bear: u8 = 46;
const Wolf: u8 = 47;
const Mantis: u8 = 48;
const Spider: u8 = 49;
const Rat: u8 = 50;

// Brute T1s
const Kraken: u8 = 51;
const Colossus: u8 = 52;
const Balrog: u8 = 53;
const Leviathan: u8 = 54;
const Tarrasque: u8 = 55;

// Brute T2s
const Titan: u8 = 56;
const Nephilim: u8 = 57;
const Behemoth: u8 = 58;
const Hydra: u8 = 59;
const Juggernaut: u8 = 60;

// Brute T3s
const Oni: u8 = 61;
const Jotunn: u8 = 62;
const Ettin: u8 = 63;
const Cyclops: u8 = 64;
const Giant: u8 = 65;

// Brute T4s
const NemeanLion: u8 = 66;
const Berserker: u8 = 67;
const Yeti: u8 = 68;
const Golem: u8 = 69;
const Ent: u8 = 70;

// Brute T5s
const Troll: u8 = 71;
const Bigfoot: u8 = 72;
const Ogre: u8 = 73;
const Orc: u8 = 74;
const Skeleton: u8 = 75;

fn getBeastName(beast: u8) -> felt252 {
    if beast == Chimera {
        return 'Chimera';
    } else {
        return '';
    }
}

fn getBeastPixels(beast: u8) -> LongString {
    let mut content = ArrayTrait::<felt252>::new();

    if beast == Chimera {
        content.append('data:image/png;base64,iVBORw0KG');
        content.append('goAAAANSUhEUgAAACAAAAAgCAYAAABz');
        content.append('enr0AAAAAXNSR0IArs4c6QAAAXdJREF');
        content.append('UWIXFVkkOwyAMNFEfnSfwa3opiTPM2B');
        content.append('ClrSVEwuJlvFHMrNkf6ZUdaPX8Lvt3l');
        content.append('GhqtMrnJ8eWalevM66r/xUKEUCr/f8T');
        content.append('yFwQaPUcZqfPvxkHhwKtnszLziH1a9n');
        content.append('+LBX7pKG3uiuDSGRC7qCzoXCvBGNadi');
        content.append('6IrXl3qmA2uxFMPjjV3ShY/X0aA4pU6');
        content.append('rF1H8AeWT8vIaCswFRlvPAsyOH5HinB');
        content.append('GGdQK7dsCIlKL8wMRiqDovQdChG7gP5');
        content.append('EJmwfi5jiaRb42Ez7T0V95gYcEgEFN7');
        content.append('OQ3cug7/+HAhnMTMlMeSxazB20HWc1n');
        content.append('THKEFCUvge8AD/jXuSGjgTjcTQjtE4p');
        content.append('kVmXKYMGTSPABOB6JBwFd1pWQPUM1c7');
        content.append('7rBS6NKMMfmbB0FgWERgeJEr4UL2Squ');
        content.append('jPRHR5kGTCVdp5YmcyGVPdcKYEi3Ybt');
        content.append('vvy2Zh6z7E06usqzdhdv38ooC5GTFYE');
        content.append('+b2hn6iOx4bqerP7ZNy++MgYSvGv6Q3');
        content.append('l4pZkdWJdwgAAAABJRU5ErkJggg==');
    }

    return content.into();
}

