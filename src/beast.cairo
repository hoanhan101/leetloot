use super::long_string::LongString;
use array::{ArrayTrait};
use core::traits::{Into};

// Tiers
const TIER_1: felt252 = '1';
const TIER_2: felt252 = '2';
const TIER_3: felt252 = '3';
const TIER_4: felt252 = '4';
const TIER_5: felt252 = '5';

// Types
const TYPE_MAGICAL: felt252 = 'Magical';
const TYPE_HUNTER: felt252 = 'Hunter';
const TYPE_BRUTE: felt252 = 'Brute';

// Magical T1s
const WARLOCK: u8 = 1;
const TYPHON: u8 = 2;
const JIANGSHI: u8 = 3;
const ANANSI: u8 = 4;
const BASILISK: u8 = 5;

// Magical T2s
const GORGON: u8 = 6;
const KITSUNE: u8 = 7;
const LICH: u8 = 8;
const CHIMERA: u8 = 9;
const WENDIGO: u8 = 10;

// Magical T3s
const RAKSHASA: u8 = 11;
const WEREWOLF: u8 = 12;
const BANSHEE: u8 = 13;
const DRAUGR: u8 = 14;
const VAMPIRE: u8 = 15;

// Magical T4s
const GOBLIN: u8 = 16;
const GHOUL: u8 = 17;
const WRAITH: u8 = 18;
const SPRITE: u8 = 19;
const KAPPA: u8 = 20;

// Magical T5s
const FAIRY: u8 = 21;
const LEPRECHAUN: u8 = 22;
const KELPIE: u8 = 23;
const PIXIE: u8 = 24;
const GNOME: u8 = 25;

// Hunter T1s
const GRIFFIN: u8 = 26;
const MANTICORE: u8 = 27;
const PHOENIX: u8 = 28;
const DRAGON: u8 = 29;
const MINOTAUR: u8 = 30;

// Hunter T2s
const QILIN: u8 = 31;
const AMMIT: u8 = 32;
const NUE: u8 = 33;
const SKINWALKER: u8 = 34;
const CHUPACABRA: u8 = 35;

// Hunter T3s
const WERETIGER: u8 = 36;
const WYVERN: u8 = 37;
const ROC: u8 = 38;
const HARPY: u8 = 39;
const PEGASUS: u8 = 40;

// Hunter T4s
const HIPPOGRIFF: u8 = 41;
const FENRIR: u8 = 42;
const JAGUAR: u8 = 43;
const SATORI: u8 = 44;
const DIREWOLF: u8 = 45;

// Hunter T5s
const BEAR: u8 = 46;
const WOLF: u8 = 47;
const MANTIS: u8 = 48;
const SPIDER: u8 = 49;
const RAT: u8 = 50;

// Brute T1s
const KRAKEN: u8 = 51;
const COLOSSUS: u8 = 52;
const BALROG: u8 = 53;
const LEVIATHAN: u8 = 54;
const TARRASQUE: u8 = 55;

// Brute T2s
const TITAN: u8 = 56;
const NEPHILIM: u8 = 57;
const BEHEMOTH: u8 = 58;
const HYDRA: u8 = 59;
const JUGGERNAUT: u8 = 60;

// Brute T3s
const ONI: u8 = 61;
const JOTUNN: u8 = 62;
const ETTIN: u8 = 63;
const CYCLOPS: u8 = 64;
const GIANT: u8 = 65;

// Brute T4s
const NEMEANLION: u8 = 66;
const BERSERKER: u8 = 67;
const YETI: u8 = 68;
const GOLEM: u8 = 69;
const ENT: u8 = 70;

// Brute T5s
const TROLL: u8 = 71;
const BIGFOOT: u8 = 72;
const OGRE: u8 = 73;
const ORC: u8 = 74;
const SKELETON: u8 = 75;

fn getBeastName(beast: u8) -> felt252 {
    if beast == WARLOCK {
        return 'Warlock';
    } else if beast == TYPHON {
        return 'Typhon';
    } else if beast == JIANGSHI {
        return 'Jiangshi';
    } else if beast == ANANSI {
        return 'Anansi';
    } else if beast == BASILISK {
        return 'Basilisk';
    } else if beast == GORGON {
        return 'Gorgon';
    } else if beast == KITSUNE {
        return 'Kitsune';
    } else if beast == LICH {
        return 'Lich';
    } else if beast == CHIMERA {
        return 'Chimera';
    } else if beast == WENDIGO {
        return 'Wendigo';
    } else if beast == RAKSHASA {
        return 'Rakshasa';
    } else if beast == WEREWOLF {
        return 'Werewolf';
    } else if beast == BANSHEE {
        return 'Banshee';
    } else if beast == DRAUGR {
        return 'Draugr';
    } else if beast == VAMPIRE {
        return 'Vampire';
    } else if beast == GOBLIN {
        return 'Goblin';
    } else if beast == GHOUL {
        return 'Ghoul';
    } else if beast == WRAITH {
        return 'Wraith';
    } else if beast == SPRITE {
        return 'Sprite';
    } else if beast == KAPPA {
        return 'Kappa';
    } else if beast == FAIRY {
        return 'Fairy';
    } else if beast == LEPRECHAUN {
        return 'Leprechaun';
    } else if beast == KELPIE {
        return 'Kelpie';
    } else if beast == PIXIE {
        return 'Pixie';
    } else if beast == GNOME {
        return 'Gnome';
    } else if beast == GRIFFIN {
        return 'Griffin';
    } else if beast == MANTICORE {
        return 'Manticore';
    } else if beast == PHOENIX {
        return 'Phoenix';
    } else if beast == DRAGON {
        return 'Dragon';
    } else if beast == MINOTAUR {
        return 'Minotaur';
    } else if beast == QILIN {
        return 'Qilin';
    } else if beast == AMMIT {
        return 'Ammit';
    } else if beast == NUE {
        return 'Nue';
    } else if beast == SKINWALKER {
        return 'Skinwalker';
    } else if beast == CHUPACABRA {
        return 'Chupacabra';
    } else if beast == WERETIGER {
        return 'Weretiger';
    } else if beast == WYVERN {
        return 'Wyvern';
    } else if beast == ROC {
        return 'Roc';
    } else if beast == HARPY {
        return 'Harpy';
    } else if beast == PEGASUS {
        return 'Pegasus';
    } else if beast == HIPPOGRIFF {
        return 'Hippogriff';
    } else if beast == FENRIR {
        return 'Fenrir';
    } else if beast == JAGUAR {
        return 'Jaguar';
    } else if beast == SATORI {
        return 'Satori';
    } else if beast == DIREWOLF {
        return 'DireWolf';
    } else if beast == BEAR {
        return 'Bear';
    } else if beast == WOLF {
        return 'Wolf';
    } else if beast == MANTIS {
        return 'Mantis';
    } else if beast == SPIDER {
        return 'Spider';
    } else if beast == RAT {
        return 'Rat';
    } else if beast == KRAKEN {
        return 'Kraken';
    } else if beast == COLOSSUS {
        return 'Colossus';
    } else if beast == BALROG {
        return 'Balrog';
    } else if beast == LEVIATHAN {
        return 'Leviathan';
    } else if beast == TARRASQUE {
        return 'Tarrasque';
    } else if beast == TITAN {
        return 'Titan';
    } else if beast == NEPHILIM {
        return 'Nephilim';
    } else if beast == BEHEMOTH {
        return 'Behemoth';
    } else if beast == HYDRA {
        return 'Hydra';
    } else if beast == JUGGERNAUT {
        return 'Juggernaut';
    } else if beast == ONI {
        return 'Oni';
    } else if beast == JOTUNN {
        return 'Jotunn';
    } else if beast == ETTIN {
        return 'Ettin';
    } else if beast == CYCLOPS {
        return 'Cyclops';
    } else if beast == GIANT {
        return 'Giant';
    } else if beast == NEMEANLION {
        return 'NemeanLion';
    } else if beast == BERSERKER {
        return 'Berserker';
    } else if beast == YETI {
        return 'Yeti';
    } else if beast == GOLEM {
        return 'Golem';
    } else if beast == ENT {
        return 'Ent';
    } else if beast == TROLL {
        return 'Troll';
    } else if beast == BIGFOOT {
        return 'Bigfoot';
    } else if beast == OGRE {
        return 'Ogre';
    } else if beast == ORC {
        return 'Orc';
    } else if beast == SKELETON {
        return 'Skeleton';
    } else {
        return '1337';
    }
}


fn getBeastTier(beast: u8) -> felt252 {
    if ((beast >= 1 && beast <= 5)
        || (beast >= 26 && beast <= 30)
        || (beast >= 51 && beast <= 55)) {
        return TIER_1;
    } else if ((beast >= 6 && beast <= 10)
        || (beast >= 31 && beast <= 35)
        || (beast >= 56 && beast <= 60)) {
        return TIER_2;
    } else if ((beast >= 11 && beast <= 15)
        || (beast >= 36 && beast <= 40)
        || (beast >= 61 && beast <= 65)) {
        return TIER_3;
    } else if ((beast >= 16 && beast <= 20)
        || (beast >= 41 && beast <= 45)
        || (beast >= 66 && beast <= 70)) {
        return TIER_4;
    } else if ((beast >= 21 && beast <= 25)
        || (beast >= 46 && beast <= 50)
        || (beast >= 71 && beast <= 75)) {
        return TIER_5;
    } else {
        return '1337';
    }
}

fn getBeastType(beast: u8) -> felt252 {
    if (beast >= 1 && beast <= 25) {
        return TYPE_MAGICAL;
    } else if (beast >= 26 && beast <= 50) {
        return TYPE_HUNTER;
    } else {
        return TYPE_BRUTE;
    }
}

fn getBeastPixel(beast: u8) -> LongString {
    let mut content = ArrayTrait::<felt252>::new();

    if beast == CHIMERA {
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

