use poseidon::poseidon_hash_span;
use array::{ArrayTrait};
use core::traits::{Into};

use super::long_string::LongString;
use pixel_beasts::pack::{PackableBeast};

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

// Prefixes
const PREFIX_AGONY: u8 = 1;
const PREFIX_APOCALYPSE: u8 = 2;
const PREFIX_ARMAGEDDON: u8 = 3;
const PREFIX_BEAST: u8 = 4;
const PREFIX_BEHEMOTH: u8 = 5;
const PREFIX_BLIGHT: u8 = 6;
const PREFIX_BLOOD: u8 = 7;
const PREFIX_BRAMBLE: u8 = 8;
const PREFIX_BRIMSTONE: u8 = 9;
const PREFIX_BROOD: u8 = 10;
const PREFIX_CARRION: u8 = 11;
const PREFIX_CATACLYSM: u8 = 12;
const PREFIX_CHIMERIC: u8 = 13;
const PREFIX_CORPSE: u8 = 14;
const PREFIX_CORRUPTION: u8 = 15;
const PREFIX_DAMNATION: u8 = 16;
const PREFIX_DEATH: u8 = 17;
const PREFIX_DEMON: u8 = 18;
const PREFIX_DIRE: u8 = 19;
const PREFIX_DRAGON: u8 = 20;
const PREFIX_DREAD: u8 = 21;
const PREFIX_DOOM: u8 = 22;
const PREFIX_DUSK: u8 = 23;
const PREFIX_EAGLE: u8 = 24;
const PREFIX_EMPYREAN: u8 = 25;
const PREFIX_FATE: u8 = 26;
const PREFIX_FOE: u8 = 27;
const PREFIX_GALE: u8 = 28;
const PREFIX_GHOUL: u8 = 29;
const PREFIX_GLOOM: u8 = 30;
const PREFIX_GLYPH: u8 = 31;
const PREFIX_GOLEM: u8 = 32;
const PREFIX_GRIM: u8 = 33;
const PREFIX_HATE: u8 = 34;
const PREFIX_HAVOC: u8 = 35;
const PREFIX_HONOUR: u8 = 36;
const PREFIX_HORROR: u8 = 37;
const PREFIX_HYPNOTIC: u8 = 38;
const PREFIX_KRAKEN: u8 = 39;
const PREFIX_LOATH: u8 = 40;
const PREFIX_MAELSTROM: u8 = 41;
const PREFIX_MIND: u8 = 42;
const PREFIX_MIRACLE: u8 = 43;
const PREFIX_MORBID: u8 = 44;
const PREFIX_OBLIVION: u8 = 45;
const PREFIX_ONSLAUGHT: u8 = 46;
const PREFIX_PAIN: u8 = 47;
const PREFIX_PANDEMONIUM: u8 = 48;
const PREFIX_PHOENIX: u8 = 49;
const PREFIX_PLAGUE: u8 = 50;
const PREFIX_RAGE: u8 = 51;
const PREFIX_RAPTURE: u8 = 52;
const PREFIX_RUNE: u8 = 53;
const PREFIX_SKULL: u8 = 54;
const PREFIX_SOL: u8 = 55;
const PREFIX_SOUL: u8 = 56;
const PREFIX_SORROW: u8 = 57;
const PREFIX_SPIRIT: u8 = 58;
const PREFIX_STORM: u8 = 59;
const PREFIX_TEMPEST: u8 = 60;
const PREFIX_TORMENT: u8 = 61;
const PREFIX_VENGEANCE: u8 = 62;
const PREFIX_VICTORY: u8 = 63;
const PREFIX_VIPER: u8 = 64;
const PREFIX_VORTEX: u8 = 65;
const PREFIX_WOE: u8 = 66;
const PREFIX_WRATH: u8 = 67;
const PREFIX_LIGHTS: u8 = 68;
const PREFIX_SHIMMERING: u8 = 69;

// Suffixes
const SUFFIX_BANE: u8 = 1;
const SUFFIX_ROOT: u8 = 2;
const SUFFIX_BITE: u8 = 3;
const SUFFIX_SONG: u8 = 4;
const SUFFIX_ROAR: u8 = 5;
const SUFFIX_GRASP: u8 = 6;
const SUFFIX_INSTRUMENT: u8 = 7;
const SUFFIX_GLOW: u8 = 8;
const SUFFIX_BENDER: u8 = 9;
const SUFFIX_SHADOW: u8 = 10;
const SUFFIX_WHISPER: u8 = 11;
const SUFFIX_SHOUT: u8 = 12;
const SUFFIX_GROWL: u8 = 13;
const SUFFIX_TEAR: u8 = 14;
const SUFFIX_PEAK: u8 = 15;
const SUFFIX_FORM: u8 = 16;
const SUFFIX_SUN: u8 = 17;
const SUFFIX_MOON: u8 = 18;

fn get_content(self: PackableBeast) -> Array<felt252> {
    let beast: u8 = self.id;
    let name: felt252 = get_name(beast);
    let prefix: felt252 = get_prefix(self.prefix);
    let suffix: felt252 = get_suffix(self.suffix);
    let btype: felt252 = get_type(beast);
    let tier: felt252 = get_tier(beast);
    let level: felt252 = u16_to_felt_string(self.level);
    let health: felt252 = u16_to_felt_string(self.health);

    let mut content = ArrayTrait::<felt252>::new();

    // Name & description
    content.append('data:application/json;utf8,');

    // if beast has prefix and suffix
    if (prefix != 0 && suffix != 0) {
        // include them in the name
        content.append('{"name":"\"');
        content.append(prefix);
        content.append('%20');
        content.append(suffix);
        content.append('\"%20');
        content.append(name);
    } else {
        content.append('{"name":"');
        content.append(name);
    }

    content.append('","description":"Beasts"');

    // Metadata
    content.append(',"attributes":[{"trait_type":');
    content.append('"prefix","value":"');
    content.append(prefix);
    content.append('"},{"trait_type":');
    content.append('"name","value":"');
    content.append(name);
    content.append('"},{"trait_type":');
    content.append('"suffix","value":"');
    content.append(suffix);
    content.append('"},{"trait_type":');
    content.append('"type","value":"');
    content.append(btype);
    content.append('"},{"trait_type":');
    content.append('"tier","value":');
    content.append(tier);
    content.append('},{"trait_type":');
    content.append('"level","value":');
    content.append(level);
    content.append('},{"trait_type":');
    content.append('"health","value":');
    content.append(health);
    content.append('}]');

    // Image
    content.append(',"image":"');
    content.append('data:image/svg+xml;utf8,<svg%20');
    content.append('width=\\"100%\\"%20height=\\"100%\\');
    content.append('"%20viewBox=\\"0%200%2020000%202');
    content.append('0000\\"%20xmlns=\\"http://www.w3.');
    content.append('org/2000/svg\\"><style>svg{backg');
    content.append('round-image:url(');
    content.append('data:image/png;base64,');
    let ls: LongString = get_svg(beast);
    let mut i = 0;
    loop {
        if i == ls.len {
            break;
        }
        content.append(*ls.content[i]);
        i += 1;
    };

    content.append(');background-repeat:no-repeat;b');
    content.append('ackground-size:contain;backgrou');
    content.append('nd-position:center;image-render');
    content.append('ing:-webkit-optimize-contrast;-');
    content.append('ms-interpolation-mode:nearest-n');
    content.append('eighbor;image-rendering:-moz-cr');
    content.append('isp-edges;image-rendering:pixel');
    content.append('ated;}</style></svg>"}');

    content
}

fn get_name(beast: u8) -> felt252 {
    if beast == WARLOCK {
        'Warlock'
    } else if beast == TYPHON {
        'Typhon'
    } else if beast == JIANGSHI {
        'Jiangshi'
    } else if beast == ANANSI {
        'Anansi'
    } else if beast == BASILISK {
        'Basilisk'
    } else if beast == GORGON {
        'Gorgon'
    } else if beast == KITSUNE {
        'Kitsune'
    } else if beast == LICH {
        'Lich'
    } else if beast == CHIMERA {
        'Chimera'
    } else if beast == WENDIGO {
        'Wendigo'
    } else if beast == RAKSHASA {
        'Rakshasa'
    } else if beast == WEREWOLF {
        'Werewolf'
    } else if beast == BANSHEE {
        'Banshee'
    } else if beast == DRAUGR {
        'Draugr'
    } else if beast == VAMPIRE {
        'Vampire'
    } else if beast == GOBLIN {
        'Goblin'
    } else if beast == GHOUL {
        'Ghoul'
    } else if beast == WRAITH {
        'Wraith'
    } else if beast == SPRITE {
        'Sprite'
    } else if beast == KAPPA {
        'Kappa'
    } else if beast == FAIRY {
        'Fairy'
    } else if beast == LEPRECHAUN {
        'Leprechaun'
    } else if beast == KELPIE {
        'Kelpie'
    } else if beast == PIXIE {
        'Pixie'
    } else if beast == GNOME {
        'Gnome'
    } else if beast == GRIFFIN {
        'Griffin'
    } else if beast == MANTICORE {
        'Manticore'
    } else if beast == PHOENIX {
        'Phoenix'
    } else if beast == DRAGON {
        'Dragon'
    } else if beast == MINOTAUR {
        'Minotaur'
    } else if beast == QILIN {
        'Qilin'
    } else if beast == AMMIT {
        'Ammit'
    } else if beast == NUE {
        'Nue'
    } else if beast == SKINWALKER {
        'Skinwalker'
    } else if beast == CHUPACABRA {
        'Chupacabra'
    } else if beast == WERETIGER {
        'Weretiger'
    } else if beast == WYVERN {
        'Wyvern'
    } else if beast == ROC {
        'Roc'
    } else if beast == HARPY {
        'Harpy'
    } else if beast == PEGASUS {
        'Pegasus'
    } else if beast == HIPPOGRIFF {
        'Hippogriff'
    } else if beast == FENRIR {
        'Fenrir'
    } else if beast == JAGUAR {
        'Jaguar'
    } else if beast == SATORI {
        'Satori'
    } else if beast == DIREWOLF {
        'DireWolf'
    } else if beast == BEAR {
        'Bear'
    } else if beast == WOLF {
        'Wolf'
    } else if beast == MANTIS {
        'Mantis'
    } else if beast == SPIDER {
        'Spider'
    } else if beast == RAT {
        'Rat'
    } else if beast == KRAKEN {
        'Kraken'
    } else if beast == COLOSSUS {
        'Colossus'
    } else if beast == BALROG {
        'Balrog'
    } else if beast == LEVIATHAN {
        'Leviathan'
    } else if beast == TARRASQUE {
        'Tarrasque'
    } else if beast == TITAN {
        'Titan'
    } else if beast == NEPHILIM {
        'Nephilim'
    } else if beast == BEHEMOTH {
        'Behemoth'
    } else if beast == HYDRA {
        'Hydra'
    } else if beast == JUGGERNAUT {
        'Juggernaut'
    } else if beast == ONI {
        'Oni'
    } else if beast == JOTUNN {
        'Jotunn'
    } else if beast == ETTIN {
        'Ettin'
    } else if beast == CYCLOPS {
        'Cyclops'
    } else if beast == GIANT {
        'Giant'
    } else if beast == NEMEANLION {
        'NemeanLion'
    } else if beast == BERSERKER {
        'Berserker'
    } else if beast == YETI {
        'Yeti'
    } else if beast == GOLEM {
        'Golem'
    } else if beast == ENT {
        'Ent'
    } else if beast == TROLL {
        'Troll'
    } else if beast == BIGFOOT {
        'Bigfoot'
    } else if beast == OGRE {
        'Ogre'
    } else if beast == ORC {
        'Orc'
    } else if beast == SKELETON {
        'Skeleton'
    } else {
        panic_with_felt252('Invalid beast')
    }
}

fn get_prefix(prefix: u8) -> felt252 {
    if prefix == PREFIX_AGONY {
        'Agony'
    } else if prefix == PREFIX_APOCALYPSE {
        'Apocalypse'
    } else if prefix == PREFIX_ARMAGEDDON {
        'Armageddon'
    } else if prefix == PREFIX_BEAST {
        'Beast'
    } else if prefix == PREFIX_BEHEMOTH {
        'Behemoth'
    } else if prefix == PREFIX_BLIGHT {
        'Blight'
    } else if prefix == PREFIX_BLOOD {
        'Blood'
    } else if prefix == PREFIX_BRAMBLE {
        'Bramble'
    } else if prefix == PREFIX_BRIMSTONE {
        'Brimstone'
    } else if prefix == PREFIX_BROOD {
        'Brood'
    } else if prefix == PREFIX_CARRION {
        'Carrion'
    } else if prefix == PREFIX_CATACLYSM {
        'Cataclysm'
    } else if prefix == PREFIX_CHIMERIC {
        'Chimeric'
    } else if prefix == PREFIX_CORPSE {
        'Corpse'
    } else if prefix == PREFIX_CORRUPTION {
        'Corruption'
    } else if prefix == PREFIX_DAMNATION {
        'Damnation'
    } else if prefix == PREFIX_DEATH {
        'Death'
    } else if prefix == PREFIX_DEMON {
        'Demon'
    } else if prefix == PREFIX_DIRE {
        'Dire'
    } else if prefix == PREFIX_DRAGON {
        'Dragon'
    } else if prefix == PREFIX_DREAD {
        'Dread'
    } else if prefix == PREFIX_DOOM {
        'Doom'
    } else if prefix == PREFIX_DUSK {
        'Dusk'
    } else if prefix == PREFIX_EAGLE {
        'Eagle'
    } else if prefix == PREFIX_EMPYREAN {
        'Empyrean'
    } else if prefix == PREFIX_FATE {
        'Fate'
    } else if prefix == PREFIX_FOE {
        'Foe'
    } else if prefix == PREFIX_GALE {
        'Gale'
    } else if prefix == PREFIX_GHOUL {
        'Ghoul'
    } else if prefix == PREFIX_GLOOM {
        'Gloom'
    } else if prefix == PREFIX_GLYPH {
        'Glyph'
    } else if prefix == PREFIX_GOLEM {
        'Golem'
    } else if prefix == PREFIX_GRIM {
        'Grim'
    } else if prefix == PREFIX_HATE {
        'Hate'
    } else if prefix == PREFIX_HAVOC {
        'Havoc'
    } else if prefix == PREFIX_HONOUR {
        'Honour'
    } else if prefix == PREFIX_HORROR {
        'Horror'
    } else if prefix == PREFIX_HYPNOTIC {
        'Hypnotic'
    } else if prefix == PREFIX_KRAKEN {
        'Kraken'
    } else if prefix == PREFIX_LOATH {
        'Loath'
    } else if prefix == PREFIX_MAELSTROM {
        'Maelstrom'
    } else if prefix == PREFIX_MIND {
        'Mind'
    } else if prefix == PREFIX_MIRACLE {
        'Miracle'
    } else if prefix == PREFIX_MORBID {
        'Morbid'
    } else if prefix == PREFIX_OBLIVION {
        'Oblivion'
    } else if prefix == PREFIX_ONSLAUGHT {
        'Onslaught'
    } else if prefix == PREFIX_PAIN {
        'Pain'
    } else if prefix == PREFIX_PANDEMONIUM {
        'Pandemonium'
    } else if prefix == PREFIX_PHOENIX {
        'Phoenix'
    } else if prefix == PREFIX_PLAGUE {
        'Plague'
    } else if prefix == PREFIX_RAGE {
        'Rage'
    } else if prefix == PREFIX_RAPTURE {
        'Rapture'
    } else if prefix == PREFIX_RUNE {
        'Rune'
    } else if prefix == PREFIX_SKULL {
        'Skull'
    } else if prefix == PREFIX_SOL {
        'Sol'
    } else if prefix == PREFIX_SOUL {
        'Soul'
    } else if prefix == PREFIX_SORROW {
        'Sorrow'
    } else if prefix == PREFIX_SPIRIT {
        'Spirit'
    } else if prefix == PREFIX_STORM {
        'Storm'
    } else if prefix == PREFIX_TEMPEST {
        'Tempest'
    } else if prefix == PREFIX_TORMENT {
        'Torment'
    } else if prefix == PREFIX_VENGEANCE {
        'Vengeance'
    } else if prefix == PREFIX_VICTORY {
        'Victory'
    } else if prefix == PREFIX_VIPER {
        'Viper'
    } else if prefix == PREFIX_VORTEX {
        'Vortex'
    } else if prefix == PREFIX_WOE {
        'Woe'
    } else if prefix == PREFIX_WRATH {
        'Wrath'
    } else if prefix == PREFIX_LIGHTS {
        'Lights'
    } else if prefix == PREFIX_SHIMMERING {
        'Shimmering'
    } else {
        ''
    }
}

fn get_suffix(suffix: u8) -> felt252 {
    if suffix == SUFFIX_BANE {
        'Bane'
    } else if suffix == SUFFIX_ROOT {
        'Root'
    } else if suffix == SUFFIX_BITE {
        'Bite'
    } else if suffix == SUFFIX_SONG {
        'Song'
    } else if suffix == SUFFIX_ROAR {
        'Roar'
    } else if suffix == SUFFIX_GRASP {
        'Grasp'
    } else if suffix == SUFFIX_INSTRUMENT {
        'Instrument'
    } else if suffix == SUFFIX_GLOW {
        'Glow'
    } else if suffix == SUFFIX_BENDER {
        'Bender'
    } else if suffix == SUFFIX_SHADOW {
        'Shadow'
    } else if suffix == SUFFIX_WHISPER {
        'Whisper'
    } else if suffix == SUFFIX_SHOUT {
        'Shout'
    } else if suffix == SUFFIX_GROWL {
        'Growl'
    } else if suffix == SUFFIX_TEAR {
        'Tear'
    } else if suffix == SUFFIX_PEAK {
        'Peak'
    } else if suffix == SUFFIX_FORM {
        'Form'
    } else if suffix == SUFFIX_SUN {
        'Sun'
    } else if suffix == SUFFIX_MOON {
        'Moon'
    } else {
        ''
    }
}

fn get_tier(beast: u8) -> felt252 {
    if ((beast != 0 && beast <= 5)
        || (beast >= 26 && beast <= 30)
        || (beast >= 51 && beast <= 55)) {
        TIER_1
    } else if ((beast >= 6 && beast <= 10)
        || (beast >= 31 && beast <= 35)
        || (beast >= 56 && beast <= 60)) {
        TIER_2
    } else if ((beast >= 11 && beast <= 15)
        || (beast >= 36 && beast <= 40)
        || (beast >= 61 && beast <= 65)) {
        TIER_3
    } else if ((beast >= 16 && beast <= 20)
        || (beast >= 41 && beast <= 45)
        || (beast >= 66 && beast <= 70)) {
        TIER_4
    } else if ((beast >= 21 && beast <= 25)
        || (beast >= 46 && beast <= 50)
        || (beast >= 71 && beast <= 75)) {
        TIER_5
    } else {
        panic_with_felt252('Invalid beast')
    }
}

fn get_type(beast: u8) -> felt252 {
    assert(beast != 0, 'Invalid beast');
    if (beast <= 25) {
        TYPE_MAGICAL
    } else if beast <= 50 {
        TYPE_HUNTER
    } else if beast <= 75 {
        TYPE_BRUTE
    } else {
        panic_with_felt252('Invalid beast')
    }
}

fn get_hash(id: u8, prefix: u8, suffix: u8) -> felt252 {
    let mut content = ArrayTrait::new();
    content.append(id.into());
    content.append(prefix.into());
    content.append(suffix.into());
    poseidon_hash_span(content.span())
}

fn get_svg(beast: u8) -> LongString {
    if beast == ENT {
        return get_ent_svg();
    } else if beast == PEGASUS {
        return get_pegasus_svg();
    } else if beast == FAIRY {
        return get_fairy_svg();
    } else if beast == SATORI {
        return get_satori_svg();
    } else if beast == JUGGERNAUT {
        return get_juggernaut_svg();
    } else if beast == ETTIN {
        return get_ettin_svg();
    } else if beast == TROLL {
        return get_troll_svg();
    } else if beast == GRIFFIN {
        return get_griffin_svg();
    } else if beast == KITSUNE {
        return get_kitsune_svg();
    } else if beast == SPRITE {
        return get_sprite_svg();
    } else if beast == GOBLIN {
        return get_goblin_svg();
    } else if beast == SPIDER {
        return get_spider_svg();
    } else if beast == GNOME {
        return get_gnome_svg();
    } else if beast == RAT {
        return get_rat_svg();
    } else if beast == CYCLOPS {
        return get_cyclops_svg();
    } else if beast == BIGFOOT {
        return get_bigfoot_svg();
    } else if beast == TARRASQUE {
        return get_tarraque_svg();
    } else if beast == KELPIE {
        return get_kelpie_svg();
    } else if beast == TYPHON {
        return get_typhon_svg();
    } else if beast == OGRE {
        return get_ogre_svg();
    } else if beast == ANANSI {
        return get_anansi_svg();
    } else if beast == JIANGSHI {
        return get_jiangshi_svg();
    } else if beast == WEREWOLF {
        return get_werewolf_svg();
    } else if beast == LEVIATHAN {
        return get_leviathan_svg();
    } else if beast == GORGON {
        return get_gorgon_svg();
    } else if beast == SKINWALKER {
        return get_skinwalker_svg();
    } else if beast == ORC {
        return get_orc_svg();
    } else if beast == BANSHEE {
        return get_banshee_svg();
    } else if beast == ROC {
        return get_roc_svg();
    } else if beast == BASILISK {
        return get_basilisk_svg();
    } else if beast == HARPY {
        return get_harpy_svg();
    } else if beast == HIPPOGRIFF {
        return get_hippogriff_svg();
    } else if beast == JAGUAR {
        return get_jaguar_svg();
    } else if beast == JOTUNN {
        return get_jotunn_svg();
    } else if beast == NEPHILIM {
        return get_nephilim_svg();
    } else if beast == DIREWOLF {
        return get_direwolf_svg();
    } else if beast == LICH {
        return get_lich_svg();
    } else if beast == VAMPIRE {
        return get_vampire_svg();
    } else if beast == NEMEANLION {
        return get_nemeanlion_svg();
    } else if beast == DRAUGR {
        return get_draugr_svg();
    } else if beast == BALROG {
        return get_balrog_svg();
    } else if beast == MANTIS {
        return get_mantis_svg();
    } else if beast == WARLOCK {
        return get_warlock_svg();
    } else if beast == KRAKEN {
        return get_kraken_svg();
    } else if beast == LEPRECHAUN {
        return get_leprechaun_svg();
    } else if beast == CHIMERA {
        return get_chimera_svg();
    } else if beast == ONI {
        return get_oni_svg();
    } else if beast == MINOTAUR {
        return get_minotaur_svg();
    } else if beast == WOLF {
        return get_wolf_svg();
    } else if beast == WRAITH {
        return get_wraith_svg();
    } else if beast == KAPPA {
        return get_kappa_svg();
    } else if beast == COLOSSUS {
        return get_colossus_svg();
    } else if beast == HYDRA {
        return get_hydra_svg();
    } else if beast == YETI {
        return get_yeti_svg();
    } else if beast == PHOENIX {
        return get_phoenix_svg();
    } else if beast == WERETIGER {
        return get_weretiger_svg();
    } else if beast == WYVERN {
        return get_wyvern_svg();
    } else if beast == SKELETON {
        return get_skeleton_svg();
    } else if beast == CHUPACABRA {
        return get_chupacabra_svg();
    } else if beast == BEHEMOTH {
        return get_behemoth_svg();
    } else if beast == QILIN {
        return get_qilin_svg();
    } else if beast == NUE {
        return get_nue_svg();
    } else if beast == FENRIR {
        return get_fenrir_svg();
    } else if beast == WENDIGO {
        return get_wendigo_svg();
    } else if beast == GHOUL {
        return get_ghoul_svg();
    } else if beast == PIXIE {
        return get_pixie_svg();
    } else if beast == AMMIT {
        return get_ammit_svg();
    } else if beast == BERSERKER {
        return get_berserker_svg();
    } else if beast == RAKSHASA {
        return get_rakshasa_svg();
    } else if beast == BEAR {
        return get_bear_svg();
    } else if beast == TITAN {
        return get_titan_svg();
    } else if beast == GOLEM {
        return get_golem_svg();
    } else if beast == MANTICORE {
        return get_manticore_svg();
    } else if beast == DRAGON {
        return get_dragon_svg();
    } else if beast == GIANT {
        return get_giant_svg();
    } else {
        panic_with_felt252('Invalid beast')
    }
}

#[inline(always)]
fn get_ent_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAABVQTFRFAAAAAAAAAP8A/4gAjAC/A');
    content.append('AD/////XlWhuwAAAAd0Uk5TAP//////');
    content.append('/6V/pvsAAADfSURBVDiNbVOBFsQgCBL');
    content.append('+/6NvpSj2bmsty5BCg9+DrwFngNOINM');
    content.append('8MoxZAtex6R4D5Xi+A5cOaRiBXKa/6q');
    content.append('NBRuxonGcjEdShT0B3qjgtB8+i/sBKB');
    content.append('vpttCmEOh4Vze5Fc8EOjEIQx3MdNIbT');
    content.append('L2XaICbIcOAgO8B7YEfqYfxDAvumUoI');
    content.append('FirxeNaouDqYhJohFrNJ4wTtL01mXRb');
    content.append('5LvOzcaK8JkzUbwCDTDtVjYujjAE+bx');
    content.append('gHNorfzZOameVV5sjxiJrbBMtWiOgtC');
    content.append('gPMJTVirYxKnNrlUJOoc8pWfrDt4eP2');
    content.append('/BBYMauZByAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_pegasus_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAVRJREFUWIW9V1EWwyAI073e/8ruZ');
    content.append('04EAmG142edJRKCou2ttdEok26dgxB2');
    content.append('1dxnYJaMl9vuTxIYH+CcsKt3zJhPqLu');
    content.append('jMLhWoCsf/YwDT3yigM58Af1gmixSYp');
    content.append('EKCMjJs0WHhES45QsIRDLKcZ1ltqHsH');
    content.append('K8E8QF5hKRFmQ7xbMeBAln9UDC9WLVa');
    content.append('2t8QkEHvNpusNF2/jbaZfh8FYogvv2s');
    content.append('fmL8REW1ehmj7Ssz3aQx/70rHKDNv73');
    content.append('v19vFgF7AKoOBy9bcWqQFKkEmoiXoEG');
    content.append('XxrF58dY1kprKkSeEAuk92fxzlrAB0+');
    content.append('FRI8rjhztTtKXGkXIJs9AvX4uhUJeER');
    content.append('Y831/JCCJVMySuElgkoiU0Kfj3qQOEI');
    content.append('gCo8W3SBev5ZXgXHkeVMAz2yUPEZDrI');
    content.append('MrenjMPKBDdgOwh9+cSSDtaguzLSAbd');
    content.append('1TlAQF+3M+vm371mDj/bOHsDJrB6SwM');
    content.append('uoZ0AAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_fairy_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8A/////zPWC');
    content.append('AAAAAR0Uk5TAP///7MtQIgAAACxSURB');
    content.append('VDiNlZNbDsMwCARBe/87N20wDNhVlPx');
    content.append('YggmwPMwfPpsGPQEXoQ2QxKcRFlGFpx');
    content.append('G2sob1JqQdSO6byosooBEVA0DmuGMcA');
    content.append('FSRAVNFERSiCQQBPdGoRqilMd8IlcwE');
    content.append('oDsKmICje70OTlOUeQLSquhUqmASVai');
    content.append('fwZp3zQnlGEXECORTZg1cFDBbXUM4rR');
    content.append('z/P65cJh3+BbSl2dYeXeaqFODNPW6Ln');
    content.append('ST1F5inebjNt8AHUyUFa2pdeGkAAAAA');
    content.append('SUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_satori_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAUJJREFUWIXFl1sOxCAIRdHM/rfsf');
    content.append('ExN6ZWLiDZD0rSxFg4P0RYRafJHqdMZ');
    content.append('L+ONAE1dIiJFPb8AMwKU60KDTY0fhHk');
    content.append('CaM87DEJYMFsAaJAZ1xDsXQqgK7M8ZX');
    content.append('KwFm5frKLDmWjci0QwRT8VM49QGUsbz');
    content.append('glAVFNJgTsajqyGYJ3wRoQQmcoPQNRB');
    content.append('OfMOayDaE3SRG/M+lNRrPDi3f+9FiDg');
    content.append('wRgA9xLZsyUp6eqdtGsBrOgjDQCJpMM');
    content.append('bqY4ApswwXWS9KA2y+HVuGmSQ65NgJP');
    content.append('ePaEAurJ0atPIswosB6jhgnUgcqr+16');
    content.append('hpMblF0DFoS3Qa0sQdAzb8Ur7xJR8Fe');
    content.append('Brgt2RygWrRQAKl8J9cLUduSMF9FBl+');
    content.append('HsoxclloITQiI0B4icbDZSmIvAalocQ');
    content.append('H87ZnLop+QG2JHN9MT7wOzAkTAuIvIF');
    content.append('bsdiOX8KB4MAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_juggernaut_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAjAC/MJKlOQAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMpJREFUOI11');
    content.append('kwEWgzAIQyH3P/RWB0mgrk+f2v6mEDD');
    content.append('SBl7eIgeB73XudADGn/Varmc869DgVy');
    content.append('leCgygIAdMXYeEQoYpPGvPBgGSab4Bj');
    content.append('L0WzRERgJ5JzaTHMAVuAH585+FpouLW');
    content.append('WXRSVrbqroXzbdEFWCq3AiwtWDk3ADC');
    content.append('Plxh+c9UrQ8OKxYRzAVZuGiRiAHy1Hp');
    content.append('r9ABkBU5A7WIYkm1a7dEoBnKwTuieaC');
    content.append('JmkxwKogHKrC79iUJL9H80s6q9qT9mB');
    content.append('kfcmfjrwd3wAu4YFMBJ5c6EAAAAASUV');
    content.append('ORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_ettin_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAQ1JREFUSImtVlEOxSAIE/Puf2Xez');
    content.append('2YQaAWzZjGKQFUQJ+MMHUP24YJ43YAJ');
    content.append('LDmZmGEVCgz0/aJyj0NDB/V1b+8JlLb');
    content.append('pIhLMfRhdiGmXpHH0E08dHTVoBo2BYo');
    content.append('UqDYkVig23ygkqHGgfEGK0BVxadF0rs');
    content.append('/5OSpZCHArU/BZjgiIJ71vhduwkdCTO');
    content.append('hOMh+IUJF5WxD93CK2cIl4CEdooc2jN');
    content.append('cN7mxFgPB+c0cVvI9jVNSDdNaJKAQkR');
    content.append('ODhYufzLKRTB5tE3nMIs5UVD5ElDwvn');
    content.append('LJU/nhxJsS95yE1c9l18/QTgkoJSUCe');
    content.append('zAh0rVhIWwQHXxcg/0Wxn6O4g17hvCC');
    content.append('w+Oy/6BsOsnHnIi1HRyfjDxqnkLbYqn');
    content.append('InAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_troll_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAOBJREFUSImtVVsOgDAIG8b7Xxk/T');
    content.append('Izh0bULfk1XWhgd2qIfd38XZsZHyexh');
    content.append('Pc+uylyDkgMCL6+7820QBMomf5I8T8t');
    content.append('bfnT3GfatTIehBBiPCuyBtDwNUBClhK');
    content.append('GAIm/dGfGZJHhxbFRIxghI9pRKHHli4');
    content.append('fXKe9JFXWuZmWyhbt2dXolEAtiOJXWX');
    content.append('WT2LtKrJkH/u/O9lW8EGTbJTAlouPbJ');
    content.append('tMkDzSkIbMjp7VG1YpCAt/w/UvMfMma');
    content.append('DBCuDa+WsoaIDEz9mzTCbdCrSjAsQcD');
    content.append('JL6ObjPJ+wdy4kvy2DQBkbjAdZatI8b');
    content.append('L86ZAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_griffin_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAA/4AABnhFZgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMxJREFUOI2F');
    content.append('UlEWwzAIUu5/6C0JKGZ9a37SZwmgGPl');
    content.append('y4qGGCcADAvgP+NbQgIW3IxF9xyWZp4');
    content.append('z6jhwUen5UViGm7VU6gCQ4VB8UaK89B');
    content.append('9wUKZMJGI1eogHVE5pCRmtQJLZGdM1J');
    content.append('Oni3SUCp191Gwpo6T8kgyki4RpoJcA4');
    content.append('T4B1tE79hXbN0gHkZDIXAoEFn0dHcM+');
    content.append('E+KCdzyMEyC/0vD04XLWBuoQgtzWFSe');
    content.append('e4ubD2cQoFHi8PbqInfEm6UJm0B2d7h');
    content.append('YvJRknOOtg8v5wOFywUbW3VO1AAAAAB');
    content.append('JRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_kitsune_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAVdJREFUWIWtVsERwzAII7ku1p06R');
    content.append('nbKaOmn9FwsgXDKna+xDbLAYGpmdqnj');
    content.append('sPPWPhq7iXLYOc19ZHqKSJ67d/EXrTU');
    content.append('j0Q99RoLN2ZiugIVWDS+zY5hTBKJXzE');
    content.append('v1O4sSjMAoL3u2ooD2EEaU8u7YfUYPV');
    content.append('3AeiLF7UrFXvDOzEk/K/k5pdey2jxL1');
    content.append('So2G6jU6q2SserSIgx+R7GHpkizw8ix');
    content.append('XALMDhCrJS2rlfc9swDnrtV1dlYK7OY');
    content.append('sorDIOO2lFxL2sulwoAUTGQbrzTG5FA');
    content.append('B18KwKVQRb+SifDlh6YzruQJXLU3yvW');
    content.append('aM+9Gf9kxFbsTY21aF+fuuEI1n3/0UE');
    content.append('V3peA0pDGfbQWbXwtEpkIZHUdATpJGO');
    content.append('2RLSxDFLJ/r41SZm+nHzT7wG8zygArv');
    content.append('Y7u1IxUttG7UUdt3RGLlmFVCSjZ0F6V');
    content.append('wFIZsjUkTA+VrpnYDUdBRJWmw+QNAAM');
    content.append('BDX21h8UAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_sprite_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAKhJREFUOI2N');
    content.append('klEOwzAIQ5N3/0NvWlOwgWrNR2uBYwJ');
    content.append('m7T9nBWLDQV/YCb8gF9rCSIUdyaEEE4');
    content.append('EkkLcaXMo2AlaCjOLUooBB7QKJKQ4FT');
    content.append('iqGRFG4wwI6gVuBgaAp1A3tgvLzElnf');
    content.append('/Xhp1lsCV/s8EE4Os9RWTiY5rtzOOYy');
    content.append('DKm3SCZlRieUC+SmTdIN08QsBE0tCuK');
    content.append('MPwAmYUTlQXzl5ia2cbn3d++JmPx+Lj');
    content.append('wSp65nJ7wAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_goblin_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAALdJREFUOI2F');
    content.append('kwESwyAIBM3+/9FNq8CdkiaddHBc8Tj');
    content.append('IuF6e4UvWewKsfyBjz3Bv5FnmcgMSmd');
    content.append('sN8GXydwIzab6pVqtgiw5Ab4jF5oPs9');
    content.append('4Aa1QA/kyA8mKm8CgLkFFnCsUB6sWoP');
    content.append('Mw+AsojwtQA/iPRr5AUhVEIEKP3RSSR');
    content.append('D1OWjUhlKoJSjGrw/Miypwfqn7br2Xq');
    content.append('zzPAFrFvte+A0tUMLUXR85ra+dyf8A+');
    content.append('TVVZBMV9VFOdCL35wP5IQTbfyQzXAAA');
    content.append('AABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_spider_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAUtJREFUWIXFlksSxCAIRGFq7n9lZ');
    content.append('qVlSDcCJjUu46cfDWhUREz+OL4nm804');
    content.append('u6qmzlBpOhCJV0A+b4pn1pYBKuKqKqo');
    content.append('a7jmqgUhY5AprZjAdpRrIRL+L2EO0aq');
    content.append('ArLnIPIg2wO5iJjzpg4xEHInEzo/m/A');
    content.append('FSquyK+nk+LcF2IFnXh2Fg11MzMt032');
    content.append('Gu2A+bOnAxEEszg7P9bAFKz+I4hM9Xu');
    content.append('QiqMzBdnIV+FIIOOKiLsJs5F7cW8vcw');
    content.append('KBXIpwFwGCy+aawcE27L71qJjZuvGdP');
    content.append('kaRA2w9szyEGACIOMrdTpwVs/9+ScFt');
    content.append('ElQ6++5BECSCmPcAE/fC/rCxN9t2tyJ');
    content.append('EXXDS36X8syKsvP27dyPKvwj5H5j2oJ');
    content.append('uL2D3e/ahwEcy2DZl961w3/yHA2JBpJ');
    content.append('wYYBbB1wEOc/Cu0bsInRgbi0d9yP6L2');
    content.append('HHOvAngINPcDboFfHhnxxOIAAAAASUV');
    content.append('ORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_gnome_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAARBJREFUWIXVVtsOhTAIA3P+/5d3n');
    content.append('jQMYS1ostgXlwWhK5dNRWTIRhw7gz8i');
    content.append('MMY7wn1TgfP0b6jwPQX8qZ+q8D0FthL');
    content.append('I5H6SBpoACtIlobJ5FP+QQftkqpydFB');
    content.append('QYY4iqXt9srwKogA3uA4rItO4AKtAJV');
    content.append('FEiVMAGqjizaWH/vymAcpmpkP2D/E1z');
    content.append('oFtIK6DU3QZRZIwkjaRf+QsJWMNsHZH');
    content.append('w64qfiYB1xqRBVXGBEf4Oa+xrwA8cBD');
    content.append('8jMr8W6SDKBg/bBWxBTwQ82yinq3bzf');
    content.append('hgity5AklnHmSr+ECtQo5i9bOzYZkHd');
    content.append('hpUBVSXReg+sCtFf0wjUk8y3pt3LCpZ');
    content.append('F+VF6njKq8s47of0oXVW57RCEP+Hu8R');
    content.append('tg2L0sAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_rat_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAA////g93P0gAAA');
    content.append('AN0Uk5TAP//RFDWIQAAALtJREFUOI2F');
    content.append('kwEOwzAIA4n//+htSQw2dFtURWq5Gpu');
    content.append('msf6s8FvgF4Dc6tYV8LngWhO4Qk8AW7');
    content.append('xrmMB9svdNXDqs3CwiFainOSCA1a0bN');
    content.append('oDVASY5AJrAqgzHJAXGlNdp0Rtkm7OH');
    content.append('DcBD7k5UgJeYgQr6uhgCPdiz9tUjU/M');
    content.append('7eEdNkfO31GHxaH7V+CZwamDwB4W08Q');
    content.append('UomwTslIx+AiCnqEsV6rwABhTBCUird');
    content.append('iYhjAJXF82mAumzE+3vnusF6bME0K/q');
    content.append('cSgAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_cyclops_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AAAD/0o8fl');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAACySURB');
    content.append('VDiNhZMLDoQwCERp5v53XiMMDAWzaCK');
    content.append('2j39r54+Y6EjZAaxqAs1M/ghAgjQnVv');
    content.append('tp5QpuoIe4APQyNKoCkHcD3p3HHPUfg');
    content.append('DuFP/HJZdOEwrpywAWc1ugNaJLABxGr');
    content.append('BKQydr0Dnnd1CLeHtFJvBKJiD0XXXJR');
    content.append('pVqb7NO8TtQJs1AToFaJPIGvAAnB+HM');
    content.append('Y4tPPITUCr2IFMDjuQU0MPEXkhrgao+');
    content.append('Maxdr7UW4xMb/cqP62ZBbfx0owaAAAA');
    content.append('AElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_bigfoot_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAO5JREFUSInNlUsSxCAIRCH3v7Ozc');
    content.append('MoiCE37WYSFlTL46E5EpbUmIvzIhM+/');
    content.append('xY1pd+nfcBCrmBBHDgCumThykC12AdS');
    content.append('wDsICjJrUAfBeOpjdaH9S1TGrqnbG+3');
    content.append('2HS7P5/VXAyrRs0EXk6Xo36CAss9Dua');
    content.append('sxqSvdPiXZ0SyzdC3ZgF2escEdQBUp6');
    content.append('h2a7bkTxiTK6ewty0n2G6XOXZA5QN9n');
    content.append('uwwVAjdcn+veeGbG6ki58H2x0QI/6J6');
    content.append('+eTqs5Pm+cuAtHCHOjhTUoTfEdRNDLG');
    content.append('w1R+PnafZaBZ5jbmL2TmUrIzcn6nRr3');
    content.append('K93Vyzq4OP4AF6fW0LqyuFQAAAAASUV');
    content.append('ORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_tarraque_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAW5JREFUWIXFV1uOwyAMNKs9dI7QW');
    content.append('9OPypGZzNh4o02REI3jMIPxq8PMpn1x');
    content.append('/KgX8/VlAk+ROAkwsHE8Q2Ka2Zyvz/R');
    content.append('nl8UVp5J35nIFeOL4jJaIz3esdBJwMG');
    content.append('b2caxAvjLdLplhEIaRBAIjKaWD71oEF');
    content.append('GAFHsHQQhmR3x1gFQ0MqLLcZW8jV5B+');
    content.append('UIQmswoj5+OSiFwBVwaO7xxMgftY9rB');
    content.append('GLWDgKmxRhvouv1gAQy2u0Sp4UtRhMv');
    content.append('8did7yAZU7lBNSn0ACikR2/1U+UHuN4');
    content.append('48+oDy6a43zendmLExZkYoy1y2+rYEZ');
    content.append('4G6lrEikV5BlRmbynSuJ5k99oHJEFde');
    content.append('MCNtP5oEMHIGzBMP6CBY5W3kgq2ZVAc');
    content.append('v6DLOiKa1G5SNRR+kuBDqn3ylKTC4Jo');
    content.append('AN1zL7T/WAtWQioDKd6vqxkZ8SY1WhT');
    content.append('Wp0iazAQoNqz/Ge001gyXVUJKUnbSK1');
    content.append('MJ9Nl38Y0HGbvn8wdEmy2yvF/jDfxpN');
    content.append('91/a0m7AAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_kelpie_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8A/////zPWC');
    content.append('AAAAAR0Uk5TAP///7MtQIgAAADBSURB');
    content.append('VDiNhZMLDoMwDENTvfvfeWP5OS2wIqB');
    content.append('SXxPXBlt/huWEV4ACrhn3AE1yX8Efey');
    content.append('vzdYj7kBMVUgFHjWqRh9lVNkAT2sRkn');
    content.append('WyDECZ8WbG3yJ2l46lFA2cFpgwpZ1Kd');
    content.append('eRQ9ZnShPF9sQIXBShIFiN2LNd8dVks');
    content.append('gex0iM0uPgwPoXZm9+ICuO/IbDnjN6X');
    content.append('h8FwQgDWao33n5sGdBXPtn365GIFaal');
    content.append('hBhJcw0c3V4Z2mN1Kclyr+pg8z1CVC1');
    content.append('r8A1Pnr9BbUUk/lCAAAAAElFTkSuQmC');
    content.append('C');
    content.into()
}

#[inline(always)]
fn get_typhon_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('hCAYAAAC4JqlRAAABfWlDQ1BzUkdCAA');
    content.append('AokX2RPUjDQBzFX1tLRSoKZhBxyFCdW');
    content.append('hAVcdQqFKFCqBVadTC59AuaGJIUF0fB');
    content.append('teDgx2LVwcVZVwdXQRD8AHF1cVJ0kRL');
    content.append('/lxRaxHhw3I939x5374Bgo8o0q2sM0H');
    content.append('TbzKSSYi6/IkZeEUE/BIQRl5llzEpSG');
    content.append('r7j6x4Bvt4leJb/uT9Hr1qwGBAQiWeY');
    content.append('YdrE68RTm7bBeZ9YYGVZJT4njpt0QeJ');
    content.append('Hrisev3EuuRzkmYKZzcwRC8RiqYOVDm');
    content.append('ZlUyOeJI6pmk75wZzHKuctzlq1xlr35');
    content.append('C+MFvTlJa7THEYKC1iEBBEKaqigChsJ');
    content.append('WnVSLGRoP+njH3L9ErkUclXAyDGPDWi');
    content.append('QXT/4H/zu1ipOjHtJ0SQQfnGcjxEgsg');
    content.append('s0647zfew4zRMg9Axc6W3/RgOY/iS93');
    content.append('tZiR0DfNnBx3daUPeByBxh8MmRTdqUQ');
    content.append('zWCxCLyf0TflgYFboGfV6621j9MHIEt');
    content.append('dpW+Ag0NgtETZaz7v7u7s7d8zrf5+AF');
    content.append('eScpwisFufAAABh0lEQVRYhc1XUa7EI');
    content.append('AjEpofuEby1+/HWDYVhQL4eSbONIkxx');
    content.append('GF0RkXXyrNmbi55LGrZmbaxiLQA6aTf');
    content.append('xtiF/pThODIM9PRD/hwO7pJWyap+qfx');
    content.append('R7renRR1/TqQCK/RvTk/vd/kYBdaCKr');
    content.append('/VbU9bNyjYeXzJNNEQ65o/sx4E1vbMe');
    content.append('G48HZPd0++s1CJAeczqAgCA7JSECAwF');
    content.append('YIBYQA2f9dIzIbpSEgarMZ7FsTsjgrC');
    content.append('13B5y0cODj2+lEEzq9r9/Hd+BVHltuP');
    content.append('ZaV91XaQtxb74m27sFSjbHnnBAxojny');
    content.append('GNJVWI+stKdi9pZJOFtrfaAORF9glXE');
    content.append('bU74spruQWJJE3DgZR2R85bRP1t9MN5');
    content.append('heIH94GmbqeNI1KNZeuybogiggOvXsP');
    content.append('AOB4ogoDjAdRwRiAI98JFDCEHGjz9m9');
    content.append('4LIT7JyvMPrkljSe730AfXUlOapEdl7');
    content.append('YuQsJS7Yo89FXs+wyQ4UILWJVqGyRNd');
    content.append('eGUcKo5Jn8sqNZJPlvmJ2MUeBql4yHA');
    content.append('Ogmj9ZH4D7THTIdDRz0OAAAAABJRU5E');
    content.append('rkJggg==');
    content.into()
}

#[inline(always)]
fn get_ogre_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAWRJREFUWIWtV0ESAyEIw53+/8v20');
    content.append('KFNs4miK5fOKEsiYKQtIno8tN5/IVpr');
    content.append('S/6vp+AI3Hu3ZHAd/Y8RYEAGdZm5ToH');
    content.append('zCdESPH0wU0cIqNMhoQTMtKd/a+1cBh');
    content.append('A0fxEIwf9KEwduARPg5lPNmGtHM8Dgl');
    content.append('f3tW6A6vKoB6LeVAe740Q2Y7S8TcMHc');
    content.append('OmdluwTcPKoEqglVHNyfEmAgBOFrxXK');
    content.append('siPDasAROSrnp3IlnvREx0AFOlduv+I');
    content.append('1IygyMgj5twturGJSB2Ykc2G4WtoSoI');
    content.append('jhV+ysBPya7poYPF1f2wKxuJ+1GYCW9');
    content.append('O8T4mws33GAxGjhcQ1Yb9XIgPGAq8FF');
    content.append('tFQk1kFglVCqnZBZJ8Bim1JNt6TFyQd');
    content.append('QEVFHJCBAiNTpVBGnFRwlS+6yvg6+ae');
    content.append('9ikEKmPq1dO+WJZbk3oXjW8ZvlhxRSI');
    content.append('+tv2JaBOUOneChGOaXVgRuKpOWGKiLh');
    content.append('4tDrdfGj4Fy3tDQ0lUDS7MbOrAAAAAE');
    content.append('lFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_anansi_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('hCAYAAAC4JqlRAAABhGlDQ1BJQ0MgcH');
    content.append('JvZmlsZQAAKJF9kT1Iw0AcxV9bS0UqC');
    content.append('mYQcchQnVoQFXHUKhShQqgVWnUwufQL');
    content.append('mhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/AB');
    content.append('xdXFSdJES/5cUWsR4cNyPd/ced++AYK');
    content.append('PKNKtrDNB028ykkmIuvyJGXhFBPwSEE');
    content.append('ZeZZcxKUhq+4+seAb7eJXiW/7k/R69a');
    content.append('sBgQEIlnmGHaxOvEU5u2wXmfWGBlWSU');
    content.append('+J46bdEHiR64rHr9xLrkc5JmCmc3MEQ');
    content.append('vEYqmDlQ5mZVMjniSOqZpO+cGcxyrnL');
    content.append('c5atcZa9+QvjBb05SWu0xxGCgtYhAQR');
    content.append('CmqooAobCVp1UixkaD/p4x9y/RK5FHJ');
    content.append('VwMgxjw1okF0/+B/87tYqTox7SdEkEH');
    content.append('5xnI8RILILNOuO833sOM0TIPQMXOlt/');
    content.append('0YDmP4kvd7WYkdA3zZwcd3WlD3gcgcY');
    content.append('fDJkU3alEM1gsQi8n9E35YGBW6Bn1eu');
    content.append('ttY/TByBLXaVvgINDYLRE2Ws+7+7u7O');
    content.append('3fM63+fgBXknKcyUKElgAAAQ9JREFUW');
    content.append('IXFV0EOwyAMC9Me3Sf01+wwsTGrJHaC');
    content.append('ukiorVqIsZ2gNjPr9sd4Zif283vfjhq');
    content.append('Iro5++s/KeNSwv6Mdv4wokQYwEmYTlw');
    content.append('EM3av6mxX1x3cJP+jJoyQKCFmCftZMh');
    content.append('yEDGMl3gkjRH8khyKCbj/ECC6DkgR0y');
    content.append('pPoAgqjGNg+wZWqqBEjzTgYoAJiE9QD');
    content.append('rj21VkJGAAuAlv8UDH6outL+lCiLKo3');
    content.append('feoBnwKsH7Lgq6CiKqZzBKeYYAlB2hL');
    content.append('5i5IQDFZLhzZm7pLIi+YSLViplgZZAY');
    content.append('yLTgiCkXwFho3o1CPfPv4AKYk0WLrfo');
    content.append('EriMBwMVHP0CKkSmlDM2INjz/cMzXVS');
    content.append('sW27J0dKbHCsQLNgcL7AwMt80AAAAAS');
    content.append('UVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_jiangshi_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAA/4AABnhFZgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAJpJREFUOI3N');
    content.append('k0kSwCAIBIH/PzolYRkWbznEAyXY4kA');
    content.append('CcVvSfIIjWAkDkJfFLpzNHZCZgeEBf6');
    content.append('UDgYFIdCWMZzwZQDcAHiWXe4xG1JoxD');
    content.append('aZXq1LEXB5AqW8FXPEdgGoK8GoDNqU4');
    content.append('IPUzZog4UoBAjgQGtA4alMBQBmz9Ydp');
    content.append('mZpDo5QVY5FA9n86HQJsH+SXA2F/Zys');
    content.append('TphWCZrG09N3IEyUneHIcAAAAASUVOR');
    content.append('K5CYII=');
    return content.into();
}

#[inline(always)]
fn get_werewolf_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAAD/rmEGTQAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMJJREFUOI2F');
    content.append('kgsOwzAIQ8H3P/SU8DPQaKnULeHVGIj');
    content.append('onyX3DfgWZ+XfAmKH+zQ0AD+APgCWeA');
    content.append('Ha0e7hiCOoRLOKqsE8gBnRddQ2lgJWR');
    content.append('SFDoX9YZu6hcJAqdbiq8FU+g+VWU5G2');
    content.append('B6hRcxA6gPAOkkBPYRYQHuGfCEez5+7');
    content.append('lHEocejyGmMWKZmmmyRLmAf0ONLeVgs');
    content.append('Ilz1VwXEsFc1gxDOrZBqIfCyCCExJQY');
    content.append('wD9fgA1saeCEiEjyjdvK9DVzXu1Usz1');
    content.append('A6mbBSUhSCFIAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_leviathan_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAARFJREFUSImlVkEOwyAMg2mP3hP66');
    content.append('/bAxJCT2IblULUQbBISl9aU3Ve7LzFC');
    content.append('7CXRnRHC17fQf8s+6DNHwN4EPa6JuUr');
    content.append('R1/E8goE+/NKtAdPqA6x4BiOhA314pI');
    content.append('mqEhJj6jBH9sIRxQ78sqtWjdBjRXVCs');
    content.append('JZKfIdMAk4ZgbMpcF6fjbQF+HFvyaGZ');
    content.append('ztBXaKEoEt3k6HCAq6X9mbb3PO28e2L');
    content.append('2uaJVChgjyBFNBXU4ttEdTwz0LBsOh1');
    content.append('AHUmQVfVpF4o/GbUr6+hn1ozQZQeqzl');
    content.append('yU5JVudpcgK8/+Fu4W0h8XdHCncpvf7');
    content.append('LqeVu0i1WgK65ojSOQ0khPfztB7nqpt');
    content.append('W9dv4AhWlqW8VwMqjjjeMfngatj27Qy');
    content.append('wUyyWIVgAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_gorgon_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAATRJREFUWIW1V1sOwkAIROPFvJPH6');
    content.append('J16NP2RBCkzwLJOQuw+Wl4Du4qIvL0c');
    content.append('cl7mkHT2RnIXgENOtNTak+H2taSk4CX');
    content.append('PnzU7nqAcVp2364ecl/3RHBGuBCnzSn');
    content.append('QcvcfkJwU+rDqOcq3zO9IAQ+Y99GurX');
    content.append('jup5zxLz6IReX2zjzKjKvKIcmJzjp53');
    content.append('leSlEakSSzJLxH/0AhjaiHiV504aYCu');
    content.append('OvNXfrDzt/lEEsmc77nqeRgDltjtfAb');
    content.append('Ww4tXkSKYcUFTKchVhH/AKfBlGJTnBO');
    content.append('KyTFMAI+DLb5W2EZS+Hp2CdhBF2EFAk');
    content.append('OAs6StmlRDtmBloFzIhMuW/JjEMjDlS');
    content.append('5QXhSN4BdSJnBCVnrjGVHdPWo9t9sc4');
    content.append('BdSLLOidCq26nHgfSbB7qKr9wN6H/DD');
    content.append('Ci0nbY9MmAHPiTeytgXlEBhAAAAAElF');
    content.append('TkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_skinwalker_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAWxJREFUWIWtV9mtAyEMHFZpLD2lD');
    content.append('HqiNPKR8GS844u8kVZBYOzBF6QBmCii');
    content.append('Y9zmXnhW1QAArqWMKbWMS2NrXNkv0QD');
    content.append('MpVQuWifyDGX2aJnWMeYynjmNJFrdZ2');
    content.append('F2jIlPLmxj78vKRfIP74Rsfp2EnUiHU');
    content.append('o8ZbgQ84SxYklpoX9dQYR1fL9ZaTleL');
    content.append('hcfa7Lndk5FkpVzWi64HPAOaqJapYHY');
    content.append('MN6vluiUbrVvflXGXXme54q17uDxFFn');
    content.append('T7/qVqrljE7v+/lutGwFOWNVTJ/j8CO');
    content.append('quzYdCGT/eHrZglYNQzqrmxlRAOSpDp');
    content.append('KJTj3ZBlgBmJfiMSbbHIus56vLB5CUv');
    content.append('nrQyjns+uWOsCSucAsMcRSfexh8zax0');
    content.append('LGPrMRvfB0vcFcnrktNdKdkBE8dblJw');
    content.append('KtxRsQyeHwZRZCKs/8novZcIsDIeI/T');
    content.append('DEICLCwdY/NA9h3IvEVfxRlSbHyC4xB');
    content.append('EOaDLM90Js/ivR8kxgSosT70BoEuLXJ');
    content.append('FOBDgAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_orc_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAATtJREFUSImtVkkSAyEIBGv+/2VzM');
    content.append('CEEuhGteEpYmqWRUeXkzDlFRFXtR9YG');
    content.append('+ejjmn9HbsKRFdkBomT5SlxVQQUeNxQ');
    content.append('e/IW0gsWOLYI+JvTaLLSO+bIeSeXPOW');
    content.append('GYbAb/Ll/MQXZj1Wznx5j4iSafEWTNr');
    content.append('ccUJwSz9p4MNMihr6wWQeo8ilf5Ue5Q');
    content.append('9RTVedPVt4zILo1ZDsuuGNAwGAwdIgx');
    content.append('mkdPPwuALq6l2USDWx/Bzyapfp8uBwY');
    content.append('mbn8Ly67LFrYHs3jAvcJPh1MK59Fo26');
    content.append('3jstnlB2jM6qEDKy8k2mgkz25gDv5Hy');
    content.append('qthmvQ8ghNsCna1IfA8YmUzFPs5S34M');
    content.append('iRkFyOJhkZu336Bb6jdYxMvSQRIft1r');
    content.append('uIBet80boBOg05mKILrJt1bafz1GA2Z');
    content.append('xXAN0udwVmA4kXznwAX5wXBryxTNJai');
    content.append('3QAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_banshee_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AAAD/0o8fl');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAADeSURB');
    content.append('VDiNhVMBDsQwCNLw/z/frYpgl9w12bo');
    content.append('Nqwgu8s8KPaIunIcr4PvxgXD2Z3tlOH');
    content.append('A2fpcAkzSmCJwAHUAzaDJ1D5JCXqGdM');
    content.append('XiwKKazBEiS0KZZW3Suk9NI4qxUCYAk');
    content.append('MGhnULxqUzKWqNq2utvuggaQHqFKEcK');
    content.append('7w2mmIqLta/0oIuZc2BsbluKQDsRHDm');
    content.append('YN82eIDVfjoBJmG+126Wc2aHmQovFfc');
    content.append('6mRWyOhuaTdV7djPnVIOyzCq004qJq0');
    content.append('22h7JzCSS5/REfyzZup6tmaS2QWc4vr');
    content.append('54nofGZYOv9YHt/cGjd5fhNsAAAAASU');
    content.append('VORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_roc_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAMhJREFUSInNVlsOgDAI24z3vzL+G');
    content.append('h6lwBLlwyzbbAsIuNZhk9dC0MUZ+qqi');
    content.append('i1lMrk3ROwRpQPvhtrpcrCaBDU4Uroi');
    content.append('AIrZYPDoicI+VBwBC77sysQTK/Su7uu');
    content.append('PTzRDcEBpzswbqqF8777dSFKaSk+IAH');
    content.append('OQXGR7ZHKisUplkWMkQl/qdqF2G41jP');
    content.append('+ZKjTNCYoqSjOgclq7XrSHtpM6eUOFx');
    content.append('44FD6ABx4si09ahWkH3ZWO44yvw6uOi');
    content.append('BuZGD6l8qWpSHpT1o14L+1B1zYk3wE/');
    content.append('fgqAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_basilisk_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAARJJREFUSIm1VkkShDAITKh5dJ7gr');
    content.append('51DLIwsDWQcyouEppEl2Jsv5/F47QPY');
    content.append('1kV4n5r5vOxdOH2HQ3vZ5ugewW2hUo9');
    content.append('PhZAJm8gJ1vGuTsNPIbZbYX1cyKnkV1');
    content.append('NS6coY6WprpZYP9rjGbqa7MBxmO/6am');
    content.append('bXIXNJ8aBkO2aai2s1vymQohA59vK52');
    content.append('isAz5ZnwJNupyZLq+seXR6lhyvfdX70');
    content.append('TttZN1YqbhwAGt2yBoBRRdXG6d1EpfH');
    content.append('3EWJvATH2Llo/W99EIh4bdhcDzaH1dL');
    content.append('LfWSTQbg60pWElcoklhp2YTG/Gt4xNO');
    content.append('RjKaafmYAzMDHjiUa597MNDvumw7grv');
    content.append('e/DMrz3meA9Vve60zRzwcr3B4S/QLQl');
    content.append('DU0fk/7DIAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_harpy_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAAD/rmEGTQAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAL9JREFUOI2F');
    content.append('kwsOwyAMQ1Pf/9DrCv6ERmo3jQYeODF');
    content.append('ZXR9PZYD7i2eYAPw/C0Ew1fev5TyjuL');
    content.append('aP0ECq/EoROBaQMx4M3O9PJAnNhMSuL');
    content.append('wZL7NqgZDNcAJy/a0ECW8ZJKhkCMIE2');
    content.append('FUDYhxHIK5oAqzTHTwnaNErQTy1PZbK');
    content.append('Wo0wx2qlNlZ1gN11XAC+/XwDzzBzVcn');
    content.append('GF1jgBWhG2RdMiVqCK1fbZyOFoAvtw/');
    content.append('R4Au5RavnsCzYi8/QZcQ9D+3dPzA4ts');
    content.append('BSRylHBPAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_hippogriff_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMZJREFUOI2F');
    content.append('k4kOwyAMQ4P//6PXksMOZBtCKoInxzl');
    content.append('q68+y4Q57F4DfxKMAXw3AyhuGECw/Ca');
    content.append('iAHxBxEApQgXyMMKaaflCLKA8qUAS6y');
    content.append('RJIoExShM8YgLL2FXgjoLgJ2C8hISbf');
    content.append('2JGDOgjO/P2IkFnCgdbQXgfcQPmIPQC');
    content.append('RAW4FcqBLy/40QLSaAjgNZdWYNgpiVx');
    content.append('8gMz8MIIthvXflDYmYXLQsafICFku/Z');
    content.append('xLaGi2IK00AR9iH9iTA3yo8IAeWZaLe');
    content.append('9He39QFNtQUDkNPYpgAAAABJRU5ErkJ');
    content.append('ggg==');
    content.into()
}

#[inline(always)]
fn get_jaguar_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMxJREFUOI2V');
    content.append('UlEWwzAIUu5/6G1RQNe+9S39SRUBNZE');
    content.append('PJ8YdDwDcIv4AvPMCALqHk4ydpBBxIr');
    content.append('NcSiAAy3+VHsJTFVXvNIvRZCEuHGelZ');
    content.append('TsfhgIg5SYdaYkmBbm7i2MnRmL1YQ9o');
    content.append('5lk9sEEsS91GMQd7g1wAOejCmjBJf+A');
    content.append('usMQhKQHcajuCZq5tKkiitW5aAAX0l+');
    content.append('5CzOoW9MCZwU446/Ee4GeGC4PW5715J');
    content.append('/Ed8MBLdAH8GOXLo54acuNlGaHyPSj5');
    content.append('G9uYgBnJG8Cv8wJtjgUiWsDz8QAAAAB');
    content.append('JRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_jotunn_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAQ1JREFUSImtVlEWwjAIA5/3v3L90');
    content.append('cogCczK82NSIIEBndmRrPCwoMXjDGBj');
    content.append('+IlzaxPzuBd9lb9JU42nGDpWVUbNCEM');
    content.append('n/k8MZipOf6xVYq39b2O0Gkhr2XgO7v');
    content.append('XfR9xsCQDWSO30xtFzBgDnM0X0K962u');
    content.append('XjBEa/RU5R6tME8YdQMIHexamAeVMQA');
    content.append('69PpqqgRoT4qmQt2EB0iBm1rpvTbOmi');
    content.append('XIwxorOT8RtMCSMyTGN13IgPvMHxe+g');
    content.append('yLnuHrbZc2ziBSc4Ix/YzYAHXbsP2zw');
    content.append('q+XtEnq+kyhq3ten8lYMKU+iEf1ehuz');
    content.append('bcrEZ9X/BoEvmXU9C60aWvcyiwjvDEz');
    content.append('uyaPblbXgoao6mcbfJ9bMXmrpm6m8R2');
    content.append('9bAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_nephilim_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AjAC/THy84');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAACpSURB');
    content.append('VDiNrZONDsQgCINH+v7vfJmApYK5XHL');
    content.append('G+fuNleoe+1KeHADwrkwEeJffitUOEX');
    content.append('zTSyU0Ako3AK4AkKX/ArmFWxYrgew6s');
    content.append('NKLLAtRgHTCxCpanS67iGY1dgbxYAIA');
    content.append('Dg7AhW0N5TwEsHx3BuKYgmhALIQDzFQ');
    content.append('jlGbUkEleNfA0Rw0SoWsgxol+wqReIu');
    content.append('wsbBBpR1WANtAIBSwuUvtzfry0x0ABV');
    content.append('IDEBxciBgM4SLpkAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_direwolf_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAKZJREFUOI2V');
    content.append('k0ESxSAIQ0nuf+i/qAQi/OnUTWt9hgR');
    content.append('t4GXEF4DPAP8qJEAuAJOohwG2wkZEiW');
    content.append('Mlohe/zVzAjCPgFuhELAK2JfosMTaJM');
    content.append('IGni1qfAI7QrpAi8mgAsKRwwEJgB1gA');
    content.append('BkAZmEAeZVmsjx1QzF6oDkvbD3QmBlQ');
    content.append('PZJi6MMMCTm905SpGNVQmTcXeHOh1sA');
    content.append('FVavsvRLiXG2BDJ4AXDy1qU/gB1Z4FJ');
    content.append('kIxQpEAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_lich_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AjAC/THy84');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAACnSURB');
    content.append('VDiNjZILEoAgCERx9v53rpTPAmYxjTr');
    content.append('ygAWT8WHyLDgDwPOpAWjAnYD9hSglMK');
    content.append('EGhM1yHYC70SQzsNSWHAFgpdd1mJjoQ');
    content.append('oN9V7Fi6Lyf7Iq2QgaoWxGSIq4+xgXu');
    content.append('R/wqHVQWA4NGEFgHXL1BYjEcNehQNKR');
    content.append('8BHgLL2+RYm3GCQC7s8nuEg3ICg9/VO');
    content.append('1xUyI9SgWQtpPIDtBD74HPDO8S/g7qY');
    content.append('BdzqwU9vZyI5AAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_vampire_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAAD/rmEGTQAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMRJREFUOI2N');
    content.append('UlEWwzAIUu5/6G0NIibt6/LRFyMiWiJ');
    content.append('fTngAngdAJxzSgFGHEzDyFsZ9vh/+Ae');
    content.append('AZgMXwFX3kf8lrmNB1n4JlwagKVvoKM');
    content.append('50BTNi3GZIFRTaeBDDe0rQBSinYZAMg');
    content.append('ZwvNHiMaGpANqISW2kzjX0ik7d4BpbT');
    content.append('JcvoBd/fpKFnyxlFaXq/1BMxpNpFuCv');
    content.append('29BVh9tV1dl5wAxZX6moBiQculiVcFL');
    content.append('cduaiTyVRpuIt9kcYbW44apJ7aAIXoA');
    content.append('Pn0A2q8FC6y+R30AAAAASUVORK5CYII');
    content.append('=');
    content.into()
}

#[inline(always)]
fn get_nemeanlion_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAVFJREFUWIXtVtEOAyEIw+X+/5fdy');
    content.append('y6rtRRuW7KHrclFT5EiAjoiYsYXcfsm');
    content.append('+d+AHzLAhPlhhUfj/w3yCPTAfHyn0gH');
    content.append('/g/5x3hGgvDXgVMLKK6UDxhyMvmMTYG');
    content.append('Nm7LtXBlfErGMZnkIYoVxZKN6gNhLnE');
    content.append('SgleL5DjF0hN3jGgAqycw5bNhJbB9QP');
    content.append('8nsM8CLVd2suYvUAgwmckZM+BeEF7QH');
    content.append('Mf1V4OCM6xiceew4nUZqSVJmTGUQchy');
    content.append('TvWO/kFRKPrR5QytVOXrkTBHkE3gWcf');
    content.append('lUaVlWwif065mBULfez9Q2s13FW6xVB');
    content.append('lQUKaSl2wkFtRXaxQOXiKjNU5FdZU3i');
    content.append('xZ6+6qN6IfJyr34SOHMtup2wL7G9CVp');
    content.append('AFZvc9UNQMfQTu9YPz7gHDLDz3WL96o');
    content.append('EqxatedakpbXl/FikzNu/N19UFc1XkM');
    content.append('oDLsu+h3Mkk6f+hd8zruqcKZOlY8Mk4');
    content.append('AAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_draugr_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('hCAYAAAC4JqlRAAABfWlDQ1BzUkdCAA');
    content.append('AokX2RPUjDQBzFX1tLRSoKZhBxyFCdW');
    content.append('hAVcdQqFKFCqBVadTC59AuaGJIUF0fB');
    content.append('teDgx2LVwcVZVwdXQRD8AHF1cVJ0kRL');
    content.append('/lxRaxHhw3I939x5374Bgo8o0q2sM0H');
    content.append('TbzKSSYi6/IkZeEUE/BIQRl5llzEpSG');
    content.append('r7j6x4Bvt4leJb/uT9Hr1qwGBAQiWeY');
    content.append('YdrE68RTm7bBeZ9YYGVZJT4njpt0QeJ');
    content.append('Hrisev3EuuRzkmYKZzcwRC8RiqYOVDm');
    content.append('ZlUyOeJI6pmk75wZzHKuctzlq1xlr35');
    content.append('C+MFvTlJa7THEYKC1iEBBEKaqigChsJ');
    content.append('WnVSLGRoP+njH3L9ErkUclXAyDGPDWi');
    content.append('QXT/4H/zu1ipOjHtJ0SQQfnGcjxEgsg');
    content.append('s0647zfew4zRMg9Axc6W3/RgOY/iS93');
    content.append('tZiR0DfNnBx3daUPeByBxh8MmRTdqUQ');
    content.append('zWCxCLyf0TflgYFboGfV6621j9MHIEt');
    content.append('dpW+Ag0NgtETZaz7v7u7s7d8zrf5+AF');
    content.append('eScpwisFufAAABKElEQVRYhcVXW44DM');
    content.append('Qgj1d7/yukXErJ42Emq9U/zYIIHJoYu');
    content.append('M9v2j/jMJio/zX4gsM1sJWsb5hFLIiF');
    content.append('GQB3PIOiefCIYtRpEBPCwFdZWsc9DS1');
    content.append('hrqjl2EBF46xDxd+fYx11kfC8nLEYgy');
    content.append('1h1VSdiRwRYINE6XSSB+EZ++IY52s3O');
    content.append('M6oDATdfsJe98S7sZQKZ885ZXJ9B1IJ');
    content.append('sPNnyaAiwB1Yh5p5vCGSHVhnLSFynIB');
    content.append('7qmj8JTrS/jkDmAHEvxw+E6I7EAwKo9');
    content.append('dW1lAgwIhIdnEdBkGKsgr72sxRkOo+3');
    content.append('4b6jF76BrA9g0vOEQKyAVvw+l2J0jmN');
    content.append('Hl5r5+xCkuOuEp2ePCCCqyig21hyBqh');
    content.append('Bl88r5k36gw70ICQQyPTCY961XBfJ/A');
    content.append('VsJdRJfR89eOWNH3K0AAAAASUVORK5C');
    content.append('YII=');
    content.into()
}

#[inline(always)]
fn get_balrog_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAA/4AABnhFZgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAM9JREFUOI2t');
    content.append('UkkSA0EIQv7/6GRasHEuuSQ1FRV3bNS');
    content.append('PH1qQ3PgAsNUIRzgEE03BLQbG49FXbK');
    content.append('XVk/EEcLtfIQV3VlRPOFARZDaJCMXBH');
    content.append('k0fSkdAI6v/zCbsWyFGjMJ3zFmzhhqm');
    content.append('X0TF/snHIWolVXZvBeWr3EVD472F6pP');
    content.append('ucm9RHoPmwWpfc0j1rmMcHCY4V5Nxgr');
    content.append('Be0Zb3ReWR1tEOD1RW7zL/hrHMqGMY1');
    content.append('7gsju0ZJpMhBCNz4g5T788V3tIBe/Uk');
    content.append('pYmyGo+9bhoiafMgxwcWBAVgSaxWswA');
    content.append('AAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_mantis_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAXtJREFUWIXFV9mOAzEIM9H+/y+zT');
    content.append('xkxLuboPixS1U447CFAUgPg+Ec5SuHu');
    content.append('cM+5xXX1W8VjG0OSAXeHmT3GZtYS6Wy');
    content.append('i/sYHkgxE5f3O3ozXlI2ZSXIA8KPAr9');
    content.append('xMsK4KqgiVBDJwBuN0xq1SNp3IItwQ+');
    content.append('RYcAM7WicH4ewMOhC6otkDpsi2Y+EVd');
    content.append('2obK4WGdgHLrXjv25/p5dYECU/pJK1b');
    content.append('rgJgDnXTdwvGy9bv2MQfYKBsmKt1qWx');
    content.append('Qpd+/bkIGmMpkrrxrI3p5JRMfqbStwl');
    content.append('sPganbHkVxJB87+q0l4iURCEXSSdpYz');
    content.append('MYr6rEW30y9KOgeUZNUfiW1Sf+VMjDI');
    content.append('S8TPx//MWxFH6TVsqWWVApXpyEiqbVR');
    content.append('GyDd+UurMgi3+mwBlAd9/rwB8C0Xgya');
    content.append('KYgk6152rC7WEQ7RWQL/iLQkeBgVfut');
    content.append('zwIFkpFjoOx5MxnbK1l25lektgQ+TkM');
    content.append('FHoNPqr+TG/vwQvbc3mwX/5g+Yru7V+');
    content.append('1TtRjrtzXg7vgFKKGDVGX90zEAAAAAS');
    content.append('UVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_warlock_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAASFJREFUSIm1VW2uxCAIVE/dI+yt3');
    content.append('/vBBu0wfLVZstlQhAFGxTF+IH+frc+H');
    content.append('YVc1aj1Al0+wgKeuVjugcGkfXhGJX1r');
    content.append('+KT2K0oqkp6KzW1cjst5BXdrlQ6TV35');
    content.append('ZDsYJ9BiEUaXAKUTlL01rn9dVVGfcjD');
    content.append('7hwGyBkqVX9VKekx23ZkHVmO3PQYDqO');
    content.append('aEO6OsHppMV+gsiq/ivUaVlevaM8MhU');
    content.append('RsoosMckvQN8tM7vNsR28isAyzOmie+');
    content.append('CluWE9uKUSRW9P6T0ABnawuRy26sa4t');
    content.append('uxXHtG8A0rxqcRSpYiia9ZXCbwNuKH4');
    content.append('OUp78Gb6NyhyIUKK8g7s+QH0OH2VIjo');
    content.append('qFD0aiCk0iXGqpo327kEXfaQUwQa4I/');
    content.append('Nyh1iDIvumDsYhtPIPgYPBCOPyCoAAA');
    content.append('AAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_kraken_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAASxJREFUWIXFVtEOwyAIxGUf3U/wr');
    content.append('92TCSUcHNRtJKTWqhwIV4aILPmjvJ9s');
    content.append('XvP+Pq7mOR1dk5vL9NVCPLG3NiqZlK9');
    content.append('gG/AMjesHALahUwIBaE+swf3NeuwB02');
    content.append('uhLatr3hMKjdFee4Y9T+sQkgeikkP5w');
    content.append('ErqkUWPPEJzUdTCJNTl5kVgf0c5oSMR');
    content.append('li7yPBpvz/S79yQ0TyZkHIW5AgIyoVd');
    content.append('6es4rwSoJiYi0qDgSnRcsKOrHw3ADU/');
    content.append('eOcgCqa44B6LBgBcDRHMg4wRMaQEQkT');
    content.append('yQE8C2jNAANhJXqNaQA2Ch4pMQCp7KV');
    content.append('4frGf4CrgmouVGm5VdtM50NGgjeO2C6');
    content.append('6ngxEiYhQc/JEykx4mhsggKgdQ3Nsm5');
    content.append('YC8IxnXnsGGRBuW44aUD22zWa0R89Z+');
    content.append('QCqlz2k0H53+wAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_leprechaun_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAMNJREFUWIXtVssOwyAMc6r9/y+np');
    content.append('2g0BZaYFaQKn/q24zoBAaBYiGMl+Raw');
    content.append('BWwBAPBhX1S9jg8RmSdAVW+EtWsRvOc');
    content.append('XsBAsXgtSDkSrzmQh7UAvbEwQ6S4Avp');
    content.append('WO5IES4KscEUKFsEU0ZQ6U5CJyIX3cg');
    content.append('TJkrVGcDWLYAftwr8rIM7SAGpEhSzos');
    content.append('wAgtA+xCBBAZ8CL8sZ1HkXKg1v+tmfC');
    content.append('IgB7J9A3Jv0A74LuAdWD5jogW4Ntwio');
    content.append('Bf/c6IGVqMMvdaOAHZ92xVz90wqgAAA');
    content.append('ABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_chimera_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AjAC/THy84');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAADNSURB');
    content.append('VDiNhZNZEsMwCENhdP87t2OQWJymzk8');
    content.append('cNM9CJuZ/lvEFwKsA53kT4CDgvnQliN');
    content.append('LFMR6fFp4EcTxOCZcX40fQCLaHLJVXe');
    content.append('gqUDaQ+p93v3ryQcFS39NwISEW2ktpJ');
    content.append('iJZpGkEggn0GQZ2bKtUu5AYjqKC34FZ');
    content.append('QGFlmIMi7EBFyGS8UjOVSLAHB9fCIpW');
    content.append('gMDox6gnLQ8CxCyzr7tPKoC2seuoAhM');
    content.append('YA2MGVsKCBBjcODwsY8SVHjZ+2fk1Uy');
    content.append('4rrbIDcjAtvc3st+VnJ9AOFfBvtWFc+');
    content.append('xAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_oni_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAUNJREFUWIW9VtEOAjEIY8b//+X5Y');
    content.append('EwQ2gK70yZGc4elG6xsmdm2hG1mKz++');
    content.append('BMz5wIG/QuZ+5IC7V+6xkgiwA/8FEZC');
    content.append('VXgPf2SDAJ75LhE+ehRQluCqi7ikgIC');
    content.append('Y9FRGTYzGCHRGY1acExbV7QMHXcZJc4');
    content.append('6kTIuWqJOid7oMgINaeEakVMuGYG0je');
    content.append('+PHYIdH/R8cwrna7j0rqY+odEz2AxPh');
    content.append('EnWc95sNxrB2uyzk4hnH7F/ldlekbTS');
    content.append('NCIarLY8wtRvQhRKI2eN9DcQqYs6EkL');
    content.append('GZkRArVUFImxlEIiOaBhpNKejSOFTrd');
    content.append('PRvdgxJEi47HMN6kemVoCGBzoXrWEzG');
    content.append('47lQrVDvE0SwBst1q2h3tgCdnTndyJe');
    content.append('PcTgCz0kioVobsm1X5HffUpIqw2wOae');
    content.append('5ntjUmZs3V7oMcBegARst5QV3D0ncW8');
    content.append('ANrAhEO3Zl04AAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_minotaur_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAA/4AABnhFZgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAANhJREFUOI1l');
    content.append('k4ESwyAIQ0P+/6N3KiShc7eeQgoPpKh');
    content.append('ZZMXSAdd1Vu01FhzxnzcksJ9abeFJdA');
    content.append('T3PKp+cBLfCKLgUtwftBUIS0o25OMQK');
    content.append('TfkSk9nKJXZ9gcaFS9BvGoUWhDNqU8I');
    content.append('eJtVeIco7JNdZTqfg70S2QKmK3BuaVB');
    content.append('HMgZ1f9PqdJrpQmYbk4P9InzZ6u46I+');
    content.append('3f67qQXBZ7erSGYc9AVg4Ozf5TE8Vow');
    content.append('2qFBEw6p2gz4Y/Go15UhhZwB48AT9Bz');
    content.append('wixhPgQIeIGYCNOQaHYUxGHIaUxk8ge');
    content.append('WOAU3PiV9ywAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_wolf_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8A/////zPWC');
    content.append('AAAAAR0Uk5TAP///7MtQIgAAACxSURB');
    content.append('VDiNhZNBEsQgCAS1+v9/TsXACIi7OSS');
    content.append('RaURGHfPPM7ogFQCyxgoKeH83sUYoNo');
    content.append('TuOSglyvzMNIwAIgKZ1tDoRxe7RAQ6D');
    content.append('/z7EyADVL2dAYKZDfDpVKB4c++CaEQD');
    content.append('pPRzDceefa+RA6HVUoKcyOFD3HK1egO');
    content.append('ibgDRiXxsRsiS3jnpujqIwE5gd1uBlY');
    content.append('QRZKstZJrSdXHwy6I65hN27HF/sQs1l');
    content.append('YHP4BZ4nX43L88DwwwFYW4O0c4AAAAA');
    content.append('SUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_wraith_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMtJREFUOI2F');
    content.append('UgkOwzAIA///0dNK8BGtWiK1aSHGNlT');
    content.append('/WcUT+j7CEvDdOIeJAIGAfQDz2t8q0Q');
    content.append('MyEMqqiAqJiNVXhioCU2IvLraTxSBgq');
    content.append('zPluW8qFvCwW6q3TPgmnfLwgskmOSkr');
    content.append('oWwvIXbyG5FA9rLFjYJuqV30YXXBNLB');
    content.append('vxc6sGpIc18ohvaPrdx15Nk8PCPtR3V');
    content.append('f4wKxtMTDRbuQ8QJ3uAC2/Y8NGZdss0');
    content.append('QorwkkfNLGpjm/CZ4lQiRTOgXlbRY0v');
    content.append('SS7zZ079+BfrA1ViBPF/yQ1oAAAAAEl');
    content.append('FTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_kappa_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAALlJREFUOI2V');
    content.append('k4sOxSAIQ7H//9FblEcLLjfXLM7psRR');
    content.append('0tn408ze8A2oswLsCxtAVzgp2y90SIg');
    content.append('WahIlAG9xCbJu3EGF8S38DGBH+Uzh7V');
    content.append('aABqP4CeCWgiMky/Fmz1OKNP0ym/CyY');
    content.append('YCB0gQFkBTgdKAAi4AUZQLUGHEEOUTa');
    content.append('NUhAgCKOcpA4xbWSPLJRVo+Cq4FYYGK');
    content.append('dZQBQyckTkBfeQ2zIZxNUxiYo+rkryz');
    content.append('4LcnpXEajcRmbzcyVt7AOjLBOSqQZab');
    content.append('AAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_colossus_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAS1JREFUSImtVlsSxCAIQ6eH9gje2');
    content.append('v2w41IeAbbLR6fVEBEDlci3NcFk1vp7');
    content.append('9o1c03ZpL9mJqA1a834WzIsIRFPYwXF');
    content.append('owyAieoyfKTEYL6ApHp7PtU32Ndkhhw');
    content.append('lpw2bx3PdI5x9vdGkm7V6Ab9BbYwPMW');
    content.append('S0hTtjPR7iGecg6+5pQTmcEqmHlJAuo');
    content.append('5gJgboFMsToPBqgrxc67jdhKLG7A7in');
    content.append('v9hxfTK2SD5q/mDL19IPM61wnGydRZn');
    content.append('6MMxMTPHAvNND1BFUQNYjLLAKAR+x81');
    content.append('iTVqeN2nbeqljX+x2rYVirsv1l4eETU');
    content.append('cH/mXLgyCvnRB+X9BjJU8l4E+ntYVma');
    content.append('b6gKBq1+XmBargF34MqL/XHzQu2zZ41');
    content.append('4IGTMb1H65gE/SAv1oLeepMx2p/9LTK');
    content.append('8gPlrMBMRnvjvkAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_hydra_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAjAC/MJKlOQAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAN5JREFUOI2F');
    content.append('UwkSg0AIg/z/0a1CjtXO1PFYXUhCwOo');
    content.append('/R8Ua+F4/A7jhCDwDsI/r6PgUAVdycG');
    content.append('hVN/LmAbtk9EuD2ZRU83Lra1BbkNUI2');
    content.append('HgxYPOEcINMHWQ4jCK+BTJ+qxhWLAK3');
    content.append('73tYnT4+nKRwLDmrklFHKxDO28k2swD');
    content.append('mrKwJlieIauYNxGSHa+UKm+BQYxbBKt');
    content.append('QYm1byABIBCRIFohACxMC0HHK71PKgA');
    content.append('A4FEtkR4n5rpW6uUISvtBrCJIo865cP');
    content.append('HAj3vjTFp9Ac+6ia0+mR9H+x8IbKX0/');
    content.append('7TI+Z+wAytgWa3LC2QwAAAABJRU5Erk');
    content.append('Jggg==');
    content.into()
}

#[inline(always)]
fn get_yeti_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAPFJREFUSIm9VcsOwzAIC9H+/5ezU');
    content.append('yZabGq31VDVAwGbEB4xFFlFE5KfZljR');
    content.append('HQ6HILiGy5TCOGHJ+XEIxg6cZewFgkh');
    content.append('/WT6qoRm4TzDQIztORayQOQw5uZcQBI');
    content.append('Z0d9MN8YpiteesxbLX8WhSOyh+pSYCM');
    content.append('TNmHziNJsoxUE4QwLpDJDebB6OTW+aA');
    content.append('BhmdhKKlaJFZze6X9LdmkdMo7RvoQIt');
    content.append('WcCHoqzD2J8dUCBaHuFxq6MYoRbBsKq');
    content.append('LWcVoVNTl5geDyVZ4SPJO/EZgz0if40');
    content.append('cQuZ7bilZ2RGkKeRdm/4es6uZ8NcJpW');
    content.append('9GJGdrI1iCDBBv4CP4E1QtjzoX8AAAA');
    content.append('ASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_phoenix_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAABVQTFRFAAAAAAAAAP8A/4gAjAC/A');
    content.append('AD/////XlWhuwAAAAd0Uk5TAP//////');
    content.append('/6V/pvsAAADESURBVDiNjVIBEsMgCJP');
    content.append('L//88a0kI1q3zej2FACEw4uWMPwD47s');
    content.append('UNgL27fwHmXxBs7vlliQWBI2iZGW4rE');
    content.append('bBcl2tlIPryo+BgBo8Hr7QP3TIKCaJV');
    content.append('HKKzjRMH0+PIQV3o4RwyUBRMatchz1M');
    content.append('H5SdAfuNgXZbqTQdX0nWINszqIu2Dgd');
    content.append('Ij+2cqrdwyq81aom0ni8MRsHFoAITKo');
    content.append('g2MJNl6vzWSlK5WZi+hIdXCJACWWOCU');
    content.append('o5XQ1NBLIDhBccjJchY/zyvgA0eqBfs');
    content.append('WjmxzAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_weretiger_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAAD/rmEGTQAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAL5JREFUOI2V');
    content.append('k4sShSAIRHH//6PvJIJny6a5PUzxCCt');
    content.append('YjI8r/gAkXe9szsB89vcZohbSAQDNm5');
    content.append('1DiNTwFiKnunEg1TdQngrQCutNItGqO');
    content.append('rbMVMBBJICa0hbUesJwC5HdSFCDFVCb');
    content.append('LkC9CJ9tjHJQ6RF7UnkQZVjKwrPAAHn');
    content.append('HQPGEUKMB1hl1LXNs46rX8cgdakFg6e');
    content.append('F5MGCe43I+uk8P2LalKgExb71b93BXx');
    content.append('sHyIDFf3Cp3AWDjVU37Wzj8/Lt/R3wF');
    content.append('DuZL55YAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_wyvern_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AAAD/0o8fl');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAAC8SURB');
    content.append('VDiNnZILDsMgDEMT+f533gSx49DPpLV');
    content.append('SK/DDJIbIH088KoADqKHJNRVz2HLWVF');
    content.append('D/fn11rhcb4GqYWRELWP/Fb19utokw/');
    content.append('VILAdKlGgSwiyrMHnpE69rCCG4BJNpK');
    content.append('LXoXULhqsqNWcZ45PWOzUEwj7ulgy+w');
    content.append('4Vw0+raXDYepW7c2FUb14AOgHazO9CB');
    content.append('ztRt4Rdl4CjlPWsIHz2h7AtMAd0NPwQ');
    content.append('LtNBTp0z4EXZuhnUJjndQVeuvgb+AA3');
    content.append('cQYBxBXi6QAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_skeleton_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8A/////zPWC');
    content.append('AAAAAR0Uk5TAP///7MtQIgAAACiSURB');
    content.append('VDiNjZNRFoAgCAT17f3vXKnACoj54Ss');
    content.append('Z1zGz9Utro4e84m0V8FbREQEd/OajAk');
    content.append('5LwCJSyVUec5E6jDEsxEkoMO2kjwBmw');
    content.append('nwAuTbbv+SsGhgQQZixEALIIMgBHpiC');
    content.append('ugAIoE8pYdgSxBm6WQ+Qme0hdWDFCGi');
    content.append('+BXiAj6Qfge23yAFqfwH+ZQqgx7oDbk');
    content.append('uUkqiBnwnxVmwJ66jcxWjJpK09hJkFb');
    content.append('cnr6SEAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_chupacabra_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AjAC/THy84');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAADASURB');
    content.append('VDiNhZJZDsAgCEQhc/87N1FnoUtK+mG');
    content.append('dh8Jg9U9UrLG+b+DoZAC8AqDcWOuyjM');
    content.append('FgUwk0RAXxBLLUBEgkkldQCX3VuQEWp');
    content.append('FtWtLuAe4sywgc0E+wUk0omIMv3svI3');
    content.append('JzEApOKmAmjNJlw0MNu/TbX69DwqgZ0');
    content.append('pOugcmXqMOvlxzDbFTsoEGbjhfDCyOg');
    content.append('ZlgFOM94QEeN5o935FnzLcEZ+DZzFnu');
    content.append('EuV1S+6tsqHhRnW5cN9X1G5+w14Fg+i');
    content.append('+icuBf4F3zotd/EAAAAASUVORK5CYII');
    content.append('=');
    content.into()
}

#[inline(always)]
fn get_behemoth_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('hCAYAAAC4JqlRAAABhGlDQ1BJQ0MgcH');
    content.append('JvZmlsZQAAKJF9kT1Iw0AcxV9bS0UqC');
    content.append('mYQcchQnVoQFXHUKhShQqgVWnUwufQL');
    content.append('mhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/AB');
    content.append('xdXFSdJES/5cUWsR4cNyPd/ced++AYK');
    content.append('PKNKtrDNB028ykkmIuvyJGXhFBPwSEE');
    content.append('ZeZZcxKUhq+4+seAb7eJXiW/7k/R69a');
    content.append('sBgQEIlnmGHaxOvEU5u2wXmfWGBlWSU');
    content.append('+J46bdEHiR64rHr9xLrkc5JmCmc3MEQ');
    content.append('vEYqmDlQ5mZVMjniSOqZpO+cGcxyrnL');
    content.append('c5atcZa9+QvjBb05SWu0xxGCgtYhAQR');
    content.append('CmqooAobCVp1UixkaD/p4x9y/RK5FHJ');
    content.append('VwMgxjw1okF0/+B/87tYqTox7SdEkEH');
    content.append('5xnI8RILILNOuO833sOM0TIPQMXOlt/');
    content.append('0YDmP4kvd7WYkdA3zZwcd3WlD3gcgcY');
    content.append('fDJkU3alEM1gsQi8n9E35YGBW6Bn1eu');
    content.append('ttY/TByBLXaVvgINDYLRE2Ws+7+7u7O');
    content.append('3fM63+fgBXknKcyUKElgAAARpJREFUW');
    content.append('IXtV1EShCAIfTV7se7UMbyTR2t/loZ1');
    content.append('AUGsfvbNOJMJ8XyC2gLgwINYnwz+JwA');
    content.append('Ar4hxQT2fd2z3EaDAPOhMMofVCqo5Tj');
    content.append('YeO6XFCFiBRkiEkpDLLmHH1rWRMF3ei');
    content.append('L2pQEE9E6ygDs2uh0v2gchShAl4P+wl');
    content.append('oRIg+TP1Tv4WkWlLoAXZsZlERAKSYXa');
    content.append('340R+CGgB2/e8Kjz2HpwKkPOsUgtVAa');
    content.append('916meST1NKSuy1dbCkHJVZ+s4XAY1da');
    content.append('2zByg9rfG2NRoJn8JUDdwcnpE+63p2B');
    content.append('+pLv8J2QI1s16XPeq4A05j4LIrUdwS3');
    content.append('3Ad6XyA7Jz69qUpJJz9K7YQXodIv6tL');
    content.append('NfPoxc6FVBS0irDL4cIQJX4PGf0zcw0');
    content.append('00xKtIqzwAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_qilin_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AjAC/THy84');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAADTSURB');
    content.append('VDiNhZMLDsMgDEMT+f53bktwbIK0Mam');
    content.append('M6uVjh0b+WdH/8P5qT0BHAesFavsQzA');
    content.append('wM3LG4ShRSoUowAEHr2QAYaUjtBawj4');
    content.append('FnYBD5gZRw62UUBkn46klUCVM7KTaIy');
    content.append('WG0wrskBqD8942yf4lQrcrSQo+WwERQ');
    content.append('FGiOr+RJtATXS6oS13WLqEDowxa4Pyj');
    content.append('y1uQUrKNwid4N1TqCnJVNDBekG2oU9r');
    content.append('LZInlqf4dFyW3oj+wZiILLaxiQGBrQE');
    content.append('eCWz+hy4X+nUtc97QbPAD+L+ssZ6AJp');
    content.append('oBiX1LtEcAAAAAElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_nue_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AjAC/THy84');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAADXSURB');
    content.append('VDiNhVMJDsMwCAP5/3/eFvDRVlOzrlL');
    content.append('Bss2R6pdT3z/m/AXg/NqIC3wZJhp5IU');
    content.append('qBjeEQ/t5YAI4ISHSeDVJiAutiCIYjJ');
    content.append('JpWbFYS6Z2ZcFmRFk/WUbfKIfE2IIpi');
    content.append('IQ+JlO9WjdcqhFsaAuKL8tsQM9DeItT');
    content.append('bZBjzO9SdXjBsFtKDnHFYTgcdBgBBWu');
    content.append('YgF9U38gFB7+pIeAu8gwa0YSIIBrjFs');
    content.append('BBnAZOG02HSVseg3egBxPS5lBwJtlFy');
    content.append('FMWwjrIB77sswhcnWn3dct0LFni/xtU');
    content.append('v5wPa5watFtZaaAAAAABJRU5ErkJggg');
    content.append('==');
    content.into()
}

#[inline(always)]
fn get_fenrir_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAALRJREFUOI3N');
    content.append('UksWhDAIg9z/0GP5hlqdrS7UvnwIBdE');
    content.append('/j3yCAPvihbAwvBAWissBZ5IYHuCJYS');
    content.append('UW7Iw7xUJ6iXPYVaIdjgTXln6v4l2UE');
    content.append('NHUVoLQ+GuOh4wqpCyGDC17h4s8oPUW');
    content.append('Ok19MKQSYBP7EMkhg4IPETJuGjnYFCE');
    content.append('cQgjuFjm8XDmT5u6wRxOUytOWSQUE9U');
    content.append('ZbVBnIddyWjCvAmFM61LQ3PB36buYiQ');
    content.append('CmDUnuN6yQ8PD90jgS9NRkeyAAAAABJ');
    content.append('RU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_wendigo_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAABVQTFRFAAAAAAAAAP8A/4gAjAC/A');
    content.append('AD/////XlWhuwAAAAd0Uk5TAP//////');
    content.append('/6V/pvsAAADISURBVDiNjVIBDsQgCMO');
    content.append('k/3/z7QRKu7lkLjOipZZKrGvg+h6jNq');
    content.append('MChaHjAvwX2Js2ITGxHJHhnOcVQNM3a');
    content.append('ENEQ5/VWCJ6AJ0iixtg0rRoAixNguCW');
    content.append('+MHYRRrDFw1ZkALG6jUlG8A04MAwAOD');
    content.append('M0FaDKm4MXssOYhFrIqHP3Yh6LnlKqN');
    content.append('Vyuzz6MFRe1ia90xqeDDUJwBj6Y1eTF');
    content.append('BKTgT26S8j+7GuCCbU5FUDa3vxz54Oc');
    content.append('B6sTgLLvlYEFleN4BwDzqwZJ8Ibeqx9');
    content.append('0awciQiXInQAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_ghoul_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMZJREFUOI2V');
    content.append('U0ESxCAMUv7/6N1JCGLipU6r04oQUNd');
    content.append('+NMSTbY1J/CejawCcxdHqczBspMJg6C');
    content.append('JWAzogi3gyAMcCMeueZ3WmcgOCnEups');
    content.append('9wkFeoNqDNkPPE7aYzBE9AY3QTkWhkZ');
    content.append('AL6oH81FlSIjL4Bli5FD5SVbPckKgy6');
    content.append('REj3g+K4qVq0TQEcGrMEqLm/MC8mgLd');
    content.append('ZIvdRZafukqwPLwRguL0J8Byil7RKeo');
    content.append('gWNCbi1yHBtXw+ee6FDaBeCifR7Aa92');
    content.append('nIdX+wEw9wT/I1DR0wAAAABJRU5ErkJ');
    content.append('ggg==');
    content.into()
}

#[inline(always)]
fn get_pixie_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAA9QTFRFAAAAAAAAAP8A////AAD/t');
    content.append('OJkVwAAAAV0Uk5TAP////8c0CZSAAAA');
    content.append('kElEQVQ4ja2SCwrAIAxDK7n/nYdiP7F');
    content.append('VGZsgin3EpCrtMuRPAMAR6OWCMGCUT4');
    content.append('AyHwB0l/kWSlG5oCvWoEgAC2BVaMj1p');
    content.append('VERAXsYAcbUSGxSA1orTEmC/GwFyK44');
    content.append('rx5AcVVhvhVSGPNAzjIwZYovEwFynwH');
    content.append('QkgHPUAPwMjYAls1bwI93HhyoFOJfQt');
    content.append('nq/bgCDz8WBQVaYwgSAAAAAElFTkSuQ');
    content.append('mCC');
    content.into()
}

#[inline(always)]
fn get_ammit_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAUFJREFUWIXFVlsSgyAMXDu9mHfyG');
    content.append('N6Jo9mPFpvGPDao08wwgCZk2UDCBGDD');
    content.append('H+U5YrSi7eMF830AVrQfB5bj/u0MkC1');
    content.append('qK9re+lz2Uidby2mxcw/QVSAeGT2Sdu');
    content.append('BNtUX3LSGQO/V2qL8NsFCjTNOeAcpaG');
    content.append('gLgGwYdjqukdAv0P88mW1c0nm4LzNkw');
    content.append('hIlIn+yzWc+S0hm4QygAmWQAVzRXZ6g');
    content.append('YaccL5hSE1JGhnPA5iaNOvIWtQiYLWB');
    content.append('9TIehOupHs2WoYsUTlAeBYCbMCFKXpP');
    content.append('i4xAByzYrRzbeexQOf+UV2LKTG/xnlk');
    content.append('470fwIagUyj7ESmH4Mr679mVGWCSjtR');
    content.append('npHyF9JytiNZZoAA4hikYC7SxRj2BZE');
    content.append('5YVmGdAZ3DtfRXcRTj6k2hds+EZISZ8');
    content.append('nsgY6gqNABdCSOpgqSvlqXLhCha6wW5');
    content.append('/qpme8KK6AAAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_berserker_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
    content.append('AAAR9JREFUWIXFl8EOwyAMQ8O0//9ld');
    content.append('kJClk2csK0+tZSSh2kCHREx40G90h6I');
    content.append('N0k7a2P3JYD18vAGou+PHEQD7IEZxGr');
    content.append('bA6ng+DwFwMBzu1aOsD6GC9pgJGcBcJ');
    content.append('bsGRvLAkBqFgCdUi4dloADnNa144AaU');
    content.append('wIEac1mxdzC94n8JLt1QCgHYKmoBq/0');
    content.append('tQFYkBOAOfOlvBSjsjpQVB1gD8iu/wZ');
    content.append('wKsU/BcB0w4pX1LscmG0yrOabrngOqA');
    content.append('Bqwynklu8AAp3uC/JORGuGaCt+AwF9D');
    content.append('bCaA+qLN7depn4WqLNhsbb6ADizi9zv');
    content.append('AaC+dJjvAywZJ987ALWmWeExP8beqV8');
    content.append('duRhIotoSsHIc0FZUDeC03s1dsfvjdR');
    content.append('146b4QXWbB4w58AF2Ueh/5xGUaAAAAA');
    content.append('ElFTkSuQmCC');
    content.into()
}

#[inline(always)]
fn get_rakshasa_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAIAAAD8GO2jAAAAAXNSR0IArs4c6Q');
    content.append('AAAQtJREFUSImtVkkSwzAIM3lJp2/o/');
    content.append('79GD+l4AYRR4xwyMQbJFkvbGvFoa8rY');
    content.append('/3kQwXl0dctHcCE64ljsgtH9Vn5MmQL');
    content.append('D8CrWVqi9XFsPdW/Dt0GgMoacf/aLwa');
    content.append('LQ70wEBPv8rDokZUJurLso1Zs05MWTJ');
    content.append('1ABfYkgbDrEl2lQHzUGvS/pAn06cHIC');
    content.append('NGqMkSBGifKCaF0Wj5KMYlol02g9vo/');
    content.append('GvO9oiebISsnS0JUArvDN9SuDCEHHgR');
    content.append('ScB51B2MMdID6DcrLVifS+X5/7QyJXW');
    content.append('S0ViQ3TgL1AsL+4rJbwr5F3G52MamO+');
    content.append('YmXsWL5rPaDhF1zp3n+2jLFo1t6jGzX');
    content.append('6TiwWJKwQ8zuM3gmOfgHWEqIKfpZ+Tw');
    content.append('AAAABJRU5ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_bear_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8A/////zPWC');
    content.append('AAAAAR0Uk5TAP///7MtQIgAAACqSURB');
    content.append('VDiNhVPREoAgCIPb//9zZwlshNWDh2M');
    content.append('MZ2L+8xlvgFqFANwgIkJhi7AibDAVbm');
    content.append('hFtuOnnpaAmQAuJ0IyonJHTwW7kEOqz');
    content.append('TxcKQTNvBhRKZtoUTkoIgrlYlBotXnf');
    content.append('5QKo5vQ7iOBxRQ4/ENCMKGE0+WrxpSD');
    content.append('PZCBAsrNCuZwJfFXfLWYXf4SWL+BEOC');
    content.append('rk8ZoCwRgJNDNt/izzSFA28aohM5vD2');
    content.append('KZ7+i6bwwVnShVyQwAAAABJRU5ErkJg');
    content.append('gg==');
    content.into()
}

#[inline(always)]
fn get_titan_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('hCAYAAAC4JqlRAAABhGlDQ1BJQ0MgcH');
    content.append('JvZmlsZQAAKJF9kT1Iw0AcxV9bS0UqC');
    content.append('mYQcchQnVoQFXHUKhShQqgVWnUwufQL');
    content.append('mhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/AB');
    content.append('xdXFSdJES/5cUWsR4cNyPd/ced++AYK');
    content.append('PKNKtrDNB028ykkmIuvyJGXhFBPwSEE');
    content.append('ZeZZcxKUhq+4+seAb7eJXiW/7k/R69a');
    content.append('sBgQEIlnmGHaxOvEU5u2wXmfWGBlWSU');
    content.append('+J46bdEHiR64rHr9xLrkc5JmCmc3MEQ');
    content.append('vEYqmDlQ5mZVMjniSOqZpO+cGcxyrnL');
    content.append('c5atcZa9+QvjBb05SWu0xxGCgtYhAQR');
    content.append('CmqooAobCVp1UixkaD/p4x9y/RK5FHJ');
    content.append('VwMgxjw1okF0/+B/87tYqTox7SdEkEH');
    content.append('5xnI8RILILNOuO833sOM0TIPQMXOlt/');
    content.append('0YDmP4kvd7WYkdA3zZwcd3WlD3gcgcY');
    content.append('fDJkU3alEM1gsQi8n9E35YGBW6Bn1eu');
    content.append('ttY/TByBLXaVvgINDYLRE2Ws+7+7u7O');
    content.append('3fM63+fgBXknKcyUKElgAAAUtJREFUW');
    content.append('IW9V1sOgzAMC2gX404cgztxNPZVFGV2');
    content.append('GrfVLE0aXRu7eZFtZvaYgMtuuH7aoZh');
    content.append('5sSkCGnkkY+tLBXiS6AW/por4KJsReR');
    content.append('M3GoJdIc/AcmOZAERy2jF88wYpCb2IF');
    content.append('o4moJcjSwV4csX1SIiUhJ4sGutVwmU3');
    content.append('TNayAJb9VbEsDFISVsBuz7BEQCONCVk');
    content.append('V8VQ/l93lvegsOj/lgZZYFWSl+DcPIB');
    content.append('tlD7C4+vXs+5QHvOoWS7QWz7Bbh2fN7');
    content.append('ZUwRHHZ72kIottR+2V7qoACfGx9bVcM');
    content.append('R4G998VPK45EM+NWBaUQREGx440OI10');
    content.append('BkRyJY88M0cNwHuhNvz2wYQXZNBvsgr');
    content.append('4fZKXWK2NpIIm3ZFByY1hAlcDvRaLlP');
    content.append('yYqUF/woB5Y8Zqt9JDXAysImYjszJ6R');
    content.append('+1ELDZYzDchjaAhhZabYMGUgmUH2Qvo');
    content.append('C6Kp2/lujcjkAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_golem_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAAAP8AEEcUsgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMFJREFUOI2V');
    content.append('kwsShCAMQ2vuf+gdJUmDC8PI+EF4pmm');
    content.append('Bug6tvgK42w7Ac90PbAD9iw3wSIDXJo');
    content.append('Q6JyA0KsZivkWqh8AZmRki1doiQLMjT');
    content.append('PV8IM1OgEz4hyuBqLDL5RBD9qXAypeD');
    content.append('xwT+gHGDXaCrYYASUJLPmx4WDuAINIm');
    content.append('2ppwizfAQW4FRJmBIAQsFOo5Kvwslz+');
    content.append('K6Xt4wzIVu4LwSsDq6G1vO6UHbYwIAL');
    content.append('dk6hA5ML6RiVC5wrrTeUmAz6O/j6f4B');
    content.append('Jx0FD0j789sAAAAASUVORK5CYII=');
    content.into()
}

#[inline(always)]
fn get_manticore_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAA/4AABnhFZgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAMlJREFUOI2V');
    content.append('UwEOhDAIg/7/0acMWnAzFxejUUopBc3');
    content.append('/HPsAwLpf5x2QQZwBrlRhpwZMbNymSO');
    content.append('gZF7YumoZFcgPualhlqwuIxCIWH9FEg');
    content.append('CQWpcDEh6IoEUGqPgBA854urhLZT1PW');
    content.append('wiESLoEgTTWcGjw7ZHJmLIZdf4PNLvY');
    content.append('20gdvQhWNFyvrR7RthSlXCPgA1LRyfA');
    content.append('yphGMYcQB45XJqZb0WRvxdRjrZmKGeB');
    content.append('4DzQB+JAJTATap55T7MuGaDtpM0e/AI');
    content.append('4PvB8b/Yzw8ulgUFnTfMVQAAAABJRU5');
    content.append('ErkJggg==');
    content.into()
}

#[inline(always)]
fn get_dragon_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAlQTFRFAAAAAAAA/4AABnhFZgAAA');
    content.append('AN0Uk5TAP//RFDWIQAAAN9JREFUOI2F');
    content.append('UwESwzAIUv7/6F0iIOtuW3ttUkVUYqv');
    content.append('/XPX4xm8APhGVzvMCvgCg5YEgAGPGWY');
    content.append('EMqbHrOX6XAQJuxDUrHK2wA2AQ/Yvgt');
    content.append('jDREIBkNpa2KsMpia8GkgEuj6lLjaFN');
    content.append('IUnvXfCeFMtxYSqSWd2khKMObo0cijo');
    content.append('p7GcjyqCNAOxkGHQuV0n5VfUe5jCXjo');
    content.append('diB8WYar3RyIo9gJQvGJpS64PXgmdgN');
    content.append('h39TkEl1UFIZBgHRv6Ogdy6Stk7ETHb');
    content.append('BZshZGqugUEciXXcoY2koQKlzqAcnu3');
    content.append('iTaKPn7tf1nUFaqrjsNoAAAAASUVORK');
    content.append('5CYII=');
    content.into()
}

#[inline(always)]
fn get_giant_svg() -> LongString {
    let mut content = ArrayTrait::<felt252>::new();
    content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
    content.append('gCAMAAABEpIrGAAAAAXNSR0IArs4c6Q');
    content.append('AAAAxQTFRFAAAAAAAAAP8AAAD/0o8fl');
    content.append('wAAAAR0Uk5TAP///7MtQIgAAACwSURB');
    content.append('VDiNjZILDsQgCEQhc/87d1UYPi1xNY1');
    content.append('gHzgiopchvw/2rWUNWgacTQRGCxuAJ9');
    content.append('vYmRa9FkEKQU6xoQOAGeHDoXzE3oXt+');
    content.append('xkhMmnnPwIWXgCKEaUsMxDOF1DdDuAC');
    content.append('IOwIkJrAaoCgGhAq/OITQOcLwAR4gcc');
    content.append('MGo8VaK1DUtEBf+80C8DGY0/pC7hmyA');
    content.append('BeGqjS+3sAlM02A72svCZbOcqagBTf2');
    content.append('+ZfoNS/eKzDNB6kygX1hPndnwAAAABJ');
    content.append('RU5ErkJggg==');
    content.into()
}

fn u16_to_felt_string(number: u16) -> felt252 {
    if number == 0 {
        '0'
    } else if number == 1 {
        '1'
    } else if number == 2 {
        '2'
    } else if number == 3 {
        '3'
    } else if number == 4 {
        '4'
    } else if number == 5 {
        '5'
    } else if number == 6 {
        '6'
    } else if number == 7 {
        '7'
    } else if number == 8 {
        '8'
    } else if number == 9 {
        '9'
    } else if number == 10 {
        '10'
    } else if number == 11 {
        '11'
    } else if number == 12 {
        '12'
    } else if number == 13 {
        '13'
    } else if number == 14 {
        '14'
    } else if number == 15 {
        '15'
    } else if number == 16 {
        '16'
    } else if number == 17 {
        '17'
    } else if number == 18 {
        '18'
    } else if number == 19 {
        '19'
    } else if number == 20 {
        '20'
    } else if number == 21 {
        '21'
    } else if number == 22 {
        '22'
    } else if number == 23 {
        '23'
    } else if number == 24 {
        '24'
    } else if number == 25 {
        '25'
    } else if number == 26 {
        '26'
    } else if number == 27 {
        '27'
    } else if number == 28 {
        '28'
    } else if number == 29 {
        '29'
    } else if number == 30 {
        '30'
    } else if number == 31 {
        '31'
    } else if number == 32 {
        '32'
    } else if number == 33 {
        '33'
    } else if number == 34 {
        '34'
    } else if number == 35 {
        '35'
    } else if number == 36 {
        '36'
    } else if number == 37 {
        '37'
    } else if number == 38 {
        '38'
    } else if number == 39 {
        '39'
    } else if number == 40 {
        '40'
    } else if number == 41 {
        '41'
    } else if number == 42 {
        '42'
    } else if number == 43 {
        '43'
    } else if number == 44 {
        '44'
    } else if number == 45 {
        '45'
    } else if number == 46 {
        '46'
    } else if number == 47 {
        '47'
    } else if number == 48 {
        '48'
    } else if number == 49 {
        '49'
    } else if number == 50 {
        '50'
    } else if number == 51 {
        '51'
    } else if number == 52 {
        '52'
    } else if number == 53 {
        '53'
    } else if number == 54 {
        '54'
    } else if number == 55 {
        '55'
    } else if number == 56 {
        '56'
    } else if number == 57 {
        '57'
    } else if number == 58 {
        '58'
    } else if number == 59 {
        '59'
    } else if number == 60 {
        '60'
    } else if number == 61 {
        '61'
    } else if number == 62 {
        '62'
    } else if number == 63 {
        '63'
    } else if number == 64 {
        '64'
    } else if number == 65 {
        '65'
    } else if number == 66 {
        '66'
    } else if number == 67 {
        '67'
    } else if number == 68 {
        '68'
    } else if number == 69 {
        '69'
    } else if number == 70 {
        '70'
    } else if number == 71 {
        '71'
    } else if number == 72 {
        '72'
    } else if number == 73 {
        '73'
    } else if number == 74 {
        '74'
    } else if number == 75 {
        '75'
    } else if number == 76 {
        '76'
    } else if number == 77 {
        '77'
    } else if number == 78 {
        '78'
    } else if number == 79 {
        '79'
    } else if number == 80 {
        '80'
    } else if number == 81 {
        '81'
    } else if number == 82 {
        '82'
    } else if number == 83 {
        '83'
    } else if number == 84 {
        '84'
    } else if number == 85 {
        '85'
    } else if number == 86 {
        '86'
    } else if number == 87 {
        '87'
    } else if number == 88 {
        '88'
    } else if number == 89 {
        '89'
    } else if number == 90 {
        '90'
    } else if number == 91 {
        '91'
    } else if number == 92 {
        '92'
    } else if number == 93 {
        '93'
    } else if number == 94 {
        '94'
    } else if number == 95 {
        '95'
    } else if number == 96 {
        '96'
    } else if number == 97 {
        '97'
    } else if number == 98 {
        '98'
    } else if number == 99 {
        '99'
    } else if number == 100 {
        '100'
    } else if number == 101 {
        '101'
    } else if number == 102 {
        '102'
    } else if number == 103 {
        '103'
    } else if number == 104 {
        '104'
    } else if number == 105 {
        '105'
    } else if number == 106 {
        '106'
    } else if number == 107 {
        '107'
    } else if number == 108 {
        '108'
    } else if number == 109 {
        '109'
    } else if number == 110 {
        '110'
    } else if number == 111 {
        '111'
    } else if number == 112 {
        '112'
    } else if number == 113 {
        '113'
    } else if number == 114 {
        '114'
    } else if number == 115 {
        '115'
    } else if number == 116 {
        '116'
    } else if number == 117 {
        '117'
    } else if number == 118 {
        '118'
    } else if number == 119 {
        '119'
    } else if number == 120 {
        '120'
    } else if number == 121 {
        '121'
    } else if number == 122 {
        '122'
    } else if number == 123 {
        '123'
    } else if number == 124 {
        '124'
    } else if number == 125 {
        '125'
    } else if number == 126 {
        '126'
    } else if number == 127 {
        '127'
    } else if number == 128 {
        '128'
    } else if number == 129 {
        '129'
    } else if number == 130 {
        '130'
    } else if number == 131 {
        '131'
    } else if number == 132 {
        '132'
    } else if number == 133 {
        '133'
    } else if number == 134 {
        '134'
    } else if number == 135 {
        '135'
    } else if number == 136 {
        '136'
    } else if number == 137 {
        '137'
    } else if number == 138 {
        '138'
    } else if number == 139 {
        '139'
    } else if number == 140 {
        '140'
    } else if number == 141 {
        '141'
    } else if number == 142 {
        '142'
    } else if number == 143 {
        '143'
    } else if number == 144 {
        '144'
    } else if number == 145 {
        '145'
    } else if number == 146 {
        '146'
    } else if number == 147 {
        '147'
    } else if number == 148 {
        '148'
    } else if number == 149 {
        '149'
    } else if number == 150 {
        '150'
    } else if number == 151 {
        '151'
    } else if number == 152 {
        '152'
    } else if number == 153 {
        '153'
    } else if number == 154 {
        '154'
    } else if number == 155 {
        '155'
    } else if number == 156 {
        '156'
    } else if number == 157 {
        '157'
    } else if number == 158 {
        '158'
    } else if number == 159 {
        '159'
    } else if number == 160 {
        '160'
    } else if number == 161 {
        '161'
    } else if number == 162 {
        '162'
    } else if number == 163 {
        '163'
    } else if number == 164 {
        '164'
    } else if number == 165 {
        '165'
    } else if number == 166 {
        '166'
    } else if number == 167 {
        '167'
    } else if number == 168 {
        '168'
    } else if number == 169 {
        '169'
    } else if number == 170 {
        '170'
    } else if number == 171 {
        '171'
    } else if number == 172 {
        '172'
    } else if number == 173 {
        '173'
    } else if number == 174 {
        '174'
    } else if number == 175 {
        '175'
    } else if number == 176 {
        '176'
    } else if number == 177 {
        '177'
    } else if number == 178 {
        '178'
    } else if number == 179 {
        '179'
    } else if number == 180 {
        '180'
    } else if number == 181 {
        '181'
    } else if number == 182 {
        '182'
    } else if number == 183 {
        '183'
    } else if number == 184 {
        '184'
    } else if number == 185 {
        '185'
    } else if number == 186 {
        '186'
    } else if number == 187 {
        '187'
    } else if number == 188 {
        '188'
    } else if number == 189 {
        '189'
    } else if number == 190 {
        '190'
    } else if number == 191 {
        '191'
    } else if number == 192 {
        '192'
    } else if number == 193 {
        '193'
    } else if number == 194 {
        '194'
    } else if number == 195 {
        '195'
    } else if number == 196 {
        '196'
    } else if number == 197 {
        '197'
    } else if number == 198 {
        '198'
    } else if number == 199 {
        '199'
    } else if number == 200 {
        '200'
    } else if number == 201 {
        '201'
    } else if number == 202 {
        '202'
    } else if number == 203 {
        '203'
    } else if number == 204 {
        '204'
    } else if number == 205 {
        '205'
    } else if number == 206 {
        '206'
    } else if number == 207 {
        '207'
    } else if number == 208 {
        '208'
    } else if number == 209 {
        '209'
    } else if number == 210 {
        '210'
    } else if number == 211 {
        '211'
    } else if number == 212 {
        '212'
    } else if number == 213 {
        '213'
    } else if number == 214 {
        '214'
    } else if number == 215 {
        '215'
    } else if number == 216 {
        '216'
    } else if number == 217 {
        '217'
    } else if number == 218 {
        '218'
    } else if number == 219 {
        '219'
    } else if number == 220 {
        '220'
    } else if number == 221 {
        '221'
    } else if number == 222 {
        '222'
    } else if number == 223 {
        '223'
    } else if number == 224 {
        '224'
    } else if number == 225 {
        '225'
    } else if number == 226 {
        '226'
    } else if number == 227 {
        '227'
    } else if number == 228 {
        '228'
    } else if number == 229 {
        '229'
    } else if number == 230 {
        '230'
    } else if number == 231 {
        '231'
    } else if number == 232 {
        '232'
    } else if number == 233 {
        '233'
    } else if number == 234 {
        '234'
    } else if number == 235 {
        '235'
    } else if number == 236 {
        '236'
    } else if number == 237 {
        '237'
    } else if number == 238 {
        '238'
    } else if number == 239 {
        '239'
    } else if number == 240 {
        '240'
    } else if number == 241 {
        '241'
    } else if number == 242 {
        '242'
    } else if number == 243 {
        '243'
    } else if number == 244 {
        '244'
    } else if number == 245 {
        '245'
    } else if number == 246 {
        '246'
    } else if number == 247 {
        '247'
    } else if number == 248 {
        '248'
    } else if number == 249 {
        '249'
    } else if number == 250 {
        '250'
    } else if number == 251 {
        '251'
    } else if number == 252 {
        '252'
    } else if number == 253 {
        '253'
    } else if number == 254 {
        '254'
    } else if number == 255 {
        '255'
    } else if number == 256 {
        '256'
    } else if number == 257 {
        '257'
    } else if number == 258 {
        '258'
    } else if number == 259 {
        '259'
    } else if number == 260 {
        '260'
    } else if number == 261 {
        '261'
    } else if number == 262 {
        '262'
    } else if number == 263 {
        '263'
    } else if number == 264 {
        '264'
    } else if number == 265 {
        '265'
    } else if number == 266 {
        '266'
    } else if number == 267 {
        '267'
    } else if number == 268 {
        '268'
    } else if number == 269 {
        '269'
    } else if number == 270 {
        '270'
    } else if number == 271 {
        '271'
    } else if number == 272 {
        '272'
    } else if number == 273 {
        '273'
    } else if number == 274 {
        '274'
    } else if number == 275 {
        '275'
    } else if number == 276 {
        '276'
    } else if number == 277 {
        '277'
    } else if number == 278 {
        '278'
    } else if number == 279 {
        '279'
    } else if number == 280 {
        '280'
    } else if number == 281 {
        '281'
    } else if number == 282 {
        '282'
    } else if number == 283 {
        '283'
    } else if number == 284 {
        '284'
    } else if number == 285 {
        '285'
    } else if number == 286 {
        '286'
    } else if number == 287 {
        '287'
    } else if number == 288 {
        '288'
    } else if number == 289 {
        '289'
    } else if number == 290 {
        '290'
    } else if number == 291 {
        '291'
    } else if number == 292 {
        '292'
    } else if number == 293 {
        '293'
    } else if number == 294 {
        '294'
    } else if number == 295 {
        '295'
    } else if number == 296 {
        '296'
    } else if number == 297 {
        '297'
    } else if number == 298 {
        '298'
    } else if number == 299 {
        '299'
    } else if number == 300 {
        '300'
    } else if number == 301 {
        '301'
    } else if number == 302 {
        '302'
    } else if number == 303 {
        '303'
    } else if number == 304 {
        '304'
    } else if number == 305 {
        '305'
    } else if number == 306 {
        '306'
    } else if number == 307 {
        '307'
    } else if number == 308 {
        '308'
    } else if number == 309 {
        '309'
    } else if number == 310 {
        '310'
    } else if number == 311 {
        '311'
    } else if number == 312 {
        '312'
    } else if number == 313 {
        '313'
    } else if number == 314 {
        '314'
    } else if number == 315 {
        '315'
    } else if number == 316 {
        '316'
    } else if number == 317 {
        '317'
    } else if number == 318 {
        '318'
    } else if number == 319 {
        '319'
    } else if number == 320 {
        '320'
    } else if number == 321 {
        '321'
    } else if number == 322 {
        '322'
    } else if number == 323 {
        '323'
    } else if number == 324 {
        '324'
    } else if number == 325 {
        '325'
    } else if number == 326 {
        '326'
    } else if number == 327 {
        '327'
    } else if number == 328 {
        '328'
    } else if number == 329 {
        '329'
    } else if number == 330 {
        '330'
    } else if number == 331 {
        '331'
    } else if number == 332 {
        '332'
    } else if number == 333 {
        '333'
    } else if number == 334 {
        '334'
    } else if number == 335 {
        '335'
    } else if number == 336 {
        '336'
    } else if number == 337 {
        '337'
    } else if number == 338 {
        '338'
    } else if number == 339 {
        '339'
    } else if number == 340 {
        '340'
    } else if number == 341 {
        '341'
    } else if number == 342 {
        '342'
    } else if number == 343 {
        '343'
    } else if number == 344 {
        '344'
    } else if number == 345 {
        '345'
    } else if number == 346 {
        '346'
    } else if number == 347 {
        '347'
    } else if number == 348 {
        '348'
    } else if number == 349 {
        '349'
    } else if number == 350 {
        '350'
    } else if number == 351 {
        '351'
    } else if number == 352 {
        '352'
    } else if number == 353 {
        '353'
    } else if number == 354 {
        '354'
    } else if number == 355 {
        '355'
    } else if number == 356 {
        '356'
    } else if number == 357 {
        '357'
    } else if number == 358 {
        '358'
    } else if number == 359 {
        '359'
    } else if number == 360 {
        '360'
    } else if number == 361 {
        '361'
    } else if number == 362 {
        '362'
    } else if number == 363 {
        '363'
    } else if number == 364 {
        '364'
    } else if number == 365 {
        '365'
    } else if number == 366 {
        '366'
    } else if number == 367 {
        '367'
    } else if number == 368 {
        '368'
    } else if number == 369 {
        '369'
    } else if number == 370 {
        '370'
    } else if number == 371 {
        '371'
    } else if number == 372 {
        '372'
    } else if number == 373 {
        '373'
    } else if number == 374 {
        '374'
    } else if number == 375 {
        '375'
    } else if number == 376 {
        '376'
    } else if number == 377 {
        '377'
    } else if number == 378 {
        '378'
    } else if number == 379 {
        '379'
    } else if number == 380 {
        '380'
    } else if number == 381 {
        '381'
    } else if number == 382 {
        '382'
    } else if number == 383 {
        '383'
    } else if number == 384 {
        '384'
    } else if number == 385 {
        '385'
    } else if number == 386 {
        '386'
    } else if number == 387 {
        '387'
    } else if number == 388 {
        '388'
    } else if number == 389 {
        '389'
    } else if number == 390 {
        '390'
    } else if number == 391 {
        '391'
    } else if number == 392 {
        '392'
    } else if number == 393 {
        '393'
    } else if number == 394 {
        '394'
    } else if number == 395 {
        '395'
    } else if number == 396 {
        '396'
    } else if number == 397 {
        '397'
    } else if number == 398 {
        '398'
    } else if number == 399 {
        '399'
    } else if number == 400 {
        '400'
    } else if number == 401 {
        '401'
    } else if number == 402 {
        '402'
    } else if number == 403 {
        '403'
    } else if number == 404 {
        '404'
    } else if number == 405 {
        '405'
    } else if number == 406 {
        '406'
    } else if number == 407 {
        '407'
    } else if number == 408 {
        '408'
    } else if number == 409 {
        '409'
    } else if number == 410 {
        '410'
    } else if number == 411 {
        '411'
    } else if number == 412 {
        '412'
    } else if number == 413 {
        '413'
    } else if number == 414 {
        '414'
    } else if number == 415 {
        '415'
    } else if number == 416 {
        '416'
    } else if number == 417 {
        '417'
    } else if number == 418 {
        '418'
    } else if number == 419 {
        '419'
    } else if number == 420 {
        '420'
    } else if number == 421 {
        '421'
    } else if number == 422 {
        '422'
    } else if number == 423 {
        '423'
    } else if number == 424 {
        '424'
    } else if number == 425 {
        '425'
    } else if number == 426 {
        '426'
    } else if number == 427 {
        '427'
    } else if number == 428 {
        '428'
    } else if number == 429 {
        '429'
    } else if number == 430 {
        '430'
    } else if number == 431 {
        '431'
    } else if number == 432 {
        '432'
    } else if number == 433 {
        '433'
    } else if number == 434 {
        '434'
    } else if number == 435 {
        '435'
    } else if number == 436 {
        '436'
    } else if number == 437 {
        '437'
    } else if number == 438 {
        '438'
    } else if number == 439 {
        '439'
    } else if number == 440 {
        '440'
    } else if number == 441 {
        '441'
    } else if number == 442 {
        '442'
    } else if number == 443 {
        '443'
    } else if number == 444 {
        '444'
    } else if number == 445 {
        '445'
    } else if number == 446 {
        '446'
    } else if number == 447 {
        '447'
    } else if number == 448 {
        '448'
    } else if number == 449 {
        '449'
    } else if number == 450 {
        '450'
    } else if number == 451 {
        '451'
    } else if number == 452 {
        '452'
    } else if number == 453 {
        '453'
    } else if number == 454 {
        '454'
    } else if number == 455 {
        '455'
    } else if number == 456 {
        '456'
    } else if number == 457 {
        '457'
    } else if number == 458 {
        '458'
    } else if number == 459 {
        '459'
    } else if number == 460 {
        '460'
    } else if number == 461 {
        '461'
    } else if number == 462 {
        '462'
    } else if number == 463 {
        '463'
    } else if number == 464 {
        '464'
    } else if number == 465 {
        '465'
    } else if number == 466 {
        '466'
    } else if number == 467 {
        '467'
    } else if number == 468 {
        '468'
    } else if number == 469 {
        '469'
    } else if number == 470 {
        '470'
    } else if number == 471 {
        '471'
    } else if number == 472 {
        '472'
    } else if number == 473 {
        '473'
    } else if number == 474 {
        '474'
    } else if number == 475 {
        '475'
    } else if number == 476 {
        '476'
    } else if number == 477 {
        '477'
    } else if number == 478 {
        '478'
    } else if number == 479 {
        '479'
    } else if number == 480 {
        '480'
    } else if number == 481 {
        '481'
    } else if number == 482 {
        '482'
    } else if number == 483 {
        '483'
    } else if number == 484 {
        '484'
    } else if number == 485 {
        '485'
    } else if number == 486 {
        '486'
    } else if number == 487 {
        '487'
    } else if number == 488 {
        '488'
    } else if number == 489 {
        '489'
    } else if number == 490 {
        '490'
    } else if number == 491 {
        '491'
    } else if number == 492 {
        '492'
    } else if number == 493 {
        '493'
    } else if number == 494 {
        '494'
    } else if number == 495 {
        '495'
    } else if number == 496 {
        '496'
    } else if number == 497 {
        '497'
    } else if number == 498 {
        '498'
    } else if number == 499 {
        '499'
    } else if number == 500 {
        '500'
    } else if number == 501 {
        '501'
    } else if number == 502 {
        '502'
    } else if number == 503 {
        '503'
    } else if number == 504 {
        '504'
    } else if number == 505 {
        '505'
    } else if number == 506 {
        '506'
    } else if number == 507 {
        '507'
    } else if number == 508 {
        '508'
    } else if number == 509 {
        '509'
    } else if number == 510 {
        '510'
    } else {
        '511'
    }
}

// ---------------------------
// ---------- Tests ----------
// ---------------------------
#[cfg(test)]
mod tests {
    use core::array::ArrayTrait;
    use beasts::beast::{
        get_hash, get_type, get_tier, get_svg, get_name, get_prefix, get_suffix, u16_to_felt_string,
        get_content, TYPE_MAGICAL, TYPE_HUNTER, TYPE_BRUTE, WARLOCK, JUGGERNAUT, PEGASUS, GOBLIN,
        BEAR, FENRIR, WENDIGO, GHOUL, PIXIE, AMMIT, BERSERKER, RAKSHASA, TITAN, GOLEM, MANTICORE,
        DRAGON, GIANT, NEMEANLION, YETI, KRAKEN, MINOTAUR, PHOENIX, WYVERN, CHIMERA, GRIFFIN,
        BASILISK, KITSUNE, LICH, WEREWOLF, BANSHEE, DRAUGR, VAMPIRE, SPRITE, KAPPA, FAIRY,
        LEPRECHAUN, KELPIE, GNOME, ANANSI, TYPHON, JIANGSHI, GORGON, HYDRA, QILIN, MANTIS, HARPY,
        WRAITH, NUE, SKINWALKER, CHUPACABRA, WERETIGER, ROC, HIPPOGRIFF, JAGUAR, SATORI, DIREWOLF,
        WOLF, SPIDER, RAT, COLOSSUS, BALROG, LEVIATHAN, TARRASQUE, NEPHILIM, BEHEMOTH, ONI, JOTUNN,
        ETTIN, CYCLOPS, ENT, TROLL, BIGFOOT, OGRE, ORC, SKELETON
    };
    use beasts::pack::{PackableBeast};

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part1() {
        assert(u16_to_felt_string(0) == '0', 'wrong level for 0');
        assert(u16_to_felt_string(1) == '1', 'wrong level for 1');
        assert(u16_to_felt_string(2) == '2', 'wrong level for 2');
        assert(u16_to_felt_string(3) == '3', 'wrong level for 3');
        assert(u16_to_felt_string(4) == '4', 'wrong level for 4');
        assert(u16_to_felt_string(5) == '5', 'wrong level for 5');
        assert(u16_to_felt_string(6) == '6', 'wrong level for 6');
        assert(u16_to_felt_string(7) == '7', 'wrong level for 7');
        assert(u16_to_felt_string(8) == '8', 'wrong level for 8');
        assert(u16_to_felt_string(9) == '9', 'wrong level for 9');
        assert(u16_to_felt_string(10) == '10', 'wrong level for 10');
        assert(u16_to_felt_string(11) == '11', 'wrong level for 11');
        assert(u16_to_felt_string(12) == '12', 'wrong level for 12');
        assert(u16_to_felt_string(13) == '13', 'wrong level for 13');
        assert(u16_to_felt_string(14) == '14', 'wrong level for 14');
        assert(u16_to_felt_string(15) == '15', 'wrong level for 15');
        assert(u16_to_felt_string(16) == '16', 'wrong level for 16');
        assert(u16_to_felt_string(17) == '17', 'wrong level for 17');
        assert(u16_to_felt_string(18) == '18', 'wrong level for 18');
        assert(u16_to_felt_string(19) == '19', 'wrong level for 19');
        assert(u16_to_felt_string(20) == '20', 'wrong level for 20');
        assert(u16_to_felt_string(21) == '21', 'wrong level for 21');
        assert(u16_to_felt_string(22) == '22', 'wrong level for 22');
        assert(u16_to_felt_string(23) == '23', 'wrong level for 23');
        assert(u16_to_felt_string(24) == '24', 'wrong level for 24');
        assert(u16_to_felt_string(25) == '25', 'wrong level for 25');
        assert(u16_to_felt_string(26) == '26', 'wrong level for 26');
        assert(u16_to_felt_string(27) == '27', 'wrong level for 27');
        assert(u16_to_felt_string(28) == '28', 'wrong level for 28');
        assert(u16_to_felt_string(29) == '29', 'wrong level for 29');
        assert(u16_to_felt_string(30) == '30', 'wrong level for 30');
        assert(u16_to_felt_string(31) == '31', 'wrong level for 31');
        assert(u16_to_felt_string(32) == '32', 'wrong level for 32');
        assert(u16_to_felt_string(33) == '33', 'wrong level for 33');
        assert(u16_to_felt_string(34) == '34', 'wrong level for 34');
        assert(u16_to_felt_string(35) == '35', 'wrong level for 35');
        assert(u16_to_felt_string(36) == '36', 'wrong level for 36');
        assert(u16_to_felt_string(37) == '37', 'wrong level for 37');
        assert(u16_to_felt_string(38) == '38', 'wrong level for 38');
        assert(u16_to_felt_string(39) == '39', 'wrong level for 39');
        assert(u16_to_felt_string(40) == '40', 'wrong level for 40');
        assert(u16_to_felt_string(41) == '41', 'wrong level for 41');
        assert(u16_to_felt_string(42) == '42', 'wrong level for 42');
        assert(u16_to_felt_string(43) == '43', 'wrong level for 43');
        assert(u16_to_felt_string(44) == '44', 'wrong level for 44');
        assert(u16_to_felt_string(45) == '45', 'wrong level for 45');
        assert(u16_to_felt_string(46) == '46', 'wrong level for 46');
        assert(u16_to_felt_string(47) == '47', 'wrong level for 47');
        assert(u16_to_felt_string(48) == '48', 'wrong level for 48');
        assert(u16_to_felt_string(49) == '49', 'wrong level for 49');
        assert(u16_to_felt_string(50) == '50', 'wrong level for 50');
    }

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part2() {
        assert(u16_to_felt_string(51) == '51', 'wrong level for 51');
        assert(u16_to_felt_string(52) == '52', 'wrong level for 52');
        assert(u16_to_felt_string(53) == '53', 'wrong level for 53');
        assert(u16_to_felt_string(54) == '54', 'wrong level for 54');
        assert(u16_to_felt_string(55) == '55', 'wrong level for 55');
        assert(u16_to_felt_string(56) == '56', 'wrong level for 56');
        assert(u16_to_felt_string(57) == '57', 'wrong level for 57');
        assert(u16_to_felt_string(58) == '58', 'wrong level for 58');
        assert(u16_to_felt_string(59) == '59', 'wrong level for 59');
        assert(u16_to_felt_string(60) == '60', 'wrong level for 60');
        assert(u16_to_felt_string(61) == '61', 'wrong level for 61');
        assert(u16_to_felt_string(62) == '62', 'wrong level for 62');
        assert(u16_to_felt_string(63) == '63', 'wrong level for 63');
        assert(u16_to_felt_string(64) == '64', 'wrong level for 64');
        assert(u16_to_felt_string(65) == '65', 'wrong level for 65');
        assert(u16_to_felt_string(66) == '66', 'wrong level for 66');
        assert(u16_to_felt_string(67) == '67', 'wrong level for 67');
        assert(u16_to_felt_string(68) == '68', 'wrong level for 68');
        assert(u16_to_felt_string(69) == '69', 'wrong level for 69');
        assert(u16_to_felt_string(70) == '70', 'wrong level for 70');
        assert(u16_to_felt_string(71) == '71', 'wrong level for 71');
        assert(u16_to_felt_string(72) == '72', 'wrong level for 72');
        assert(u16_to_felt_string(73) == '73', 'wrong level for 73');
        assert(u16_to_felt_string(74) == '74', 'wrong level for 74');
        assert(u16_to_felt_string(75) == '75', 'wrong level for 75');
        assert(u16_to_felt_string(76) == '76', 'wrong level for 76');
        assert(u16_to_felt_string(77) == '77', 'wrong level for 77');
        assert(u16_to_felt_string(78) == '78', 'wrong level for 78');
        assert(u16_to_felt_string(79) == '79', 'wrong level for 79');
        assert(u16_to_felt_string(80) == '80', 'wrong level for 80');
        assert(u16_to_felt_string(81) == '81', 'wrong level for 81');
        assert(u16_to_felt_string(82) == '82', 'wrong level for 82');
        assert(u16_to_felt_string(83) == '83', 'wrong level for 83');
        assert(u16_to_felt_string(84) == '84', 'wrong level for 84');
        assert(u16_to_felt_string(85) == '85', 'wrong level for 85');
        assert(u16_to_felt_string(86) == '86', 'wrong level for 86');
        assert(u16_to_felt_string(87) == '87', 'wrong level for 87');
        assert(u16_to_felt_string(88) == '88', 'wrong level for 88');
        assert(u16_to_felt_string(89) == '89', 'wrong level for 89');
        assert(u16_to_felt_string(90) == '90', 'wrong level for 90');
        assert(u16_to_felt_string(91) == '91', 'wrong level for 91');
        assert(u16_to_felt_string(92) == '92', 'wrong level for 92');
        assert(u16_to_felt_string(93) == '93', 'wrong level for 93');
        assert(u16_to_felt_string(94) == '94', 'wrong level for 94');
        assert(u16_to_felt_string(95) == '95', 'wrong level for 95');
        assert(u16_to_felt_string(96) == '96', 'wrong level for 96');
        assert(u16_to_felt_string(97) == '97', 'wrong level for 97');
        assert(u16_to_felt_string(98) == '98', 'wrong level for 98');
        assert(u16_to_felt_string(99) == '99', 'wrong level for 99');
        assert(u16_to_felt_string(100) == '100', 'wrong level for 100');
    }

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part3() {
        assert(u16_to_felt_string(101) == '101', 'wrong level for 101');
        assert(u16_to_felt_string(102) == '102', 'wrong level for 102');
        assert(u16_to_felt_string(103) == '103', 'wrong level for 103');
        assert(u16_to_felt_string(104) == '104', 'wrong level for 104');
        assert(u16_to_felt_string(105) == '105', 'wrong level for 105');
        assert(u16_to_felt_string(106) == '106', 'wrong level for 106');
        assert(u16_to_felt_string(107) == '107', 'wrong level for 107');
        assert(u16_to_felt_string(108) == '108', 'wrong level for 108');
        assert(u16_to_felt_string(109) == '109', 'wrong level for 109');
        assert(u16_to_felt_string(110) == '110', 'wrong level for 110');
        assert(u16_to_felt_string(111) == '111', 'wrong level for 111');
        assert(u16_to_felt_string(112) == '112', 'wrong level for 112');
        assert(u16_to_felt_string(113) == '113', 'wrong level for 113');
        assert(u16_to_felt_string(114) == '114', 'wrong level for 114');
        assert(u16_to_felt_string(115) == '115', 'wrong level for 115');
        assert(u16_to_felt_string(116) == '116', 'wrong level for 116');
        assert(u16_to_felt_string(117) == '117', 'wrong level for 117');
        assert(u16_to_felt_string(118) == '118', 'wrong level for 118');
        assert(u16_to_felt_string(119) == '119', 'wrong level for 119');
        assert(u16_to_felt_string(120) == '120', 'wrong level for 120');
        assert(u16_to_felt_string(121) == '121', 'wrong level for 121');
        assert(u16_to_felt_string(122) == '122', 'wrong level for 122');
        assert(u16_to_felt_string(123) == '123', 'wrong level for 123');
        assert(u16_to_felt_string(124) == '124', 'wrong level for 124');
        assert(u16_to_felt_string(125) == '125', 'wrong level for 125');
        assert(u16_to_felt_string(126) == '126', 'wrong level for 126');
        assert(u16_to_felt_string(127) == '127', 'wrong level for 127');
        assert(u16_to_felt_string(128) == '128', 'wrong level for 128');
        assert(u16_to_felt_string(129) == '129', 'wrong level for 129');
        assert(u16_to_felt_string(130) == '130', 'wrong level for 130');
        assert(u16_to_felt_string(131) == '131', 'wrong level for 131');
        assert(u16_to_felt_string(132) == '132', 'wrong level for 132');
        assert(u16_to_felt_string(133) == '133', 'wrong level for 133');
        assert(u16_to_felt_string(134) == '134', 'wrong level for 134');
        assert(u16_to_felt_string(135) == '135', 'wrong level for 135');
        assert(u16_to_felt_string(136) == '136', 'wrong level for 136');
        assert(u16_to_felt_string(137) == '137', 'wrong level for 137');
        assert(u16_to_felt_string(138) == '138', 'wrong level for 138');
        assert(u16_to_felt_string(139) == '139', 'wrong level for 139');
        assert(u16_to_felt_string(140) == '140', 'wrong level for 140');
        assert(u16_to_felt_string(141) == '141', 'wrong level for 141');
        assert(u16_to_felt_string(142) == '142', 'wrong level for 142');
        assert(u16_to_felt_string(143) == '143', 'wrong level for 143');
        assert(u16_to_felt_string(144) == '144', 'wrong level for 144');
        assert(u16_to_felt_string(145) == '145', 'wrong level for 145');
        assert(u16_to_felt_string(146) == '146', 'wrong level for 146');
        assert(u16_to_felt_string(147) == '147', 'wrong level for 147');
        assert(u16_to_felt_string(148) == '148', 'wrong level for 148');
        assert(u16_to_felt_string(149) == '149', 'wrong level for 149');
        assert(u16_to_felt_string(150) == '150', 'wrong level for 150');
    }

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part4() {
        assert(u16_to_felt_string(151) == '151', 'wrong level for 151');
        assert(u16_to_felt_string(152) == '152', 'wrong level for 152');
        assert(u16_to_felt_string(153) == '153', 'wrong level for 153');
        assert(u16_to_felt_string(154) == '154', 'wrong level for 154');
        assert(u16_to_felt_string(155) == '155', 'wrong level for 155');
        assert(u16_to_felt_string(156) == '156', 'wrong level for 156');
        assert(u16_to_felt_string(157) == '157', 'wrong level for 157');
        assert(u16_to_felt_string(158) == '158', 'wrong level for 158');
        assert(u16_to_felt_string(159) == '159', 'wrong level for 159');
        assert(u16_to_felt_string(160) == '160', 'wrong level for 160');
        assert(u16_to_felt_string(161) == '161', 'wrong level for 161');
        assert(u16_to_felt_string(162) == '162', 'wrong level for 162');
        assert(u16_to_felt_string(163) == '163', 'wrong level for 163');
        assert(u16_to_felt_string(164) == '164', 'wrong level for 164');
        assert(u16_to_felt_string(165) == '165', 'wrong level for 165');
        assert(u16_to_felt_string(166) == '166', 'wrong level for 166');
        assert(u16_to_felt_string(167) == '167', 'wrong level for 167');
        assert(u16_to_felt_string(168) == '168', 'wrong level for 168');
        assert(u16_to_felt_string(169) == '169', 'wrong level for 169');
        assert(u16_to_felt_string(170) == '170', 'wrong level for 170');
        assert(u16_to_felt_string(171) == '171', 'wrong level for 171');
        assert(u16_to_felt_string(172) == '172', 'wrong level for 172');
        assert(u16_to_felt_string(173) == '173', 'wrong level for 173');
        assert(u16_to_felt_string(174) == '174', 'wrong level for 174');
        assert(u16_to_felt_string(175) == '175', 'wrong level for 175');
        assert(u16_to_felt_string(176) == '176', 'wrong level for 176');
        assert(u16_to_felt_string(177) == '177', 'wrong level for 177');
        assert(u16_to_felt_string(178) == '178', 'wrong level for 178');
        assert(u16_to_felt_string(179) == '179', 'wrong level for 179');
        assert(u16_to_felt_string(180) == '180', 'wrong level for 180');
        assert(u16_to_felt_string(181) == '181', 'wrong level for 181');
        assert(u16_to_felt_string(182) == '182', 'wrong level for 182');
        assert(u16_to_felt_string(183) == '183', 'wrong level for 183');
        assert(u16_to_felt_string(184) == '184', 'wrong level for 184');
        assert(u16_to_felt_string(185) == '185', 'wrong level for 185');
        assert(u16_to_felt_string(186) == '186', 'wrong level for 186');
        assert(u16_to_felt_string(187) == '187', 'wrong level for 187');
        assert(u16_to_felt_string(188) == '188', 'wrong level for 188');
        assert(u16_to_felt_string(189) == '189', 'wrong level for 189');
        assert(u16_to_felt_string(190) == '190', 'wrong level for 190');
        assert(u16_to_felt_string(191) == '191', 'wrong level for 191');
        assert(u16_to_felt_string(192) == '192', 'wrong level for 192');
        assert(u16_to_felt_string(193) == '193', 'wrong level for 193');
        assert(u16_to_felt_string(194) == '194', 'wrong level for 194');
        assert(u16_to_felt_string(195) == '195', 'wrong level for 195');
        assert(u16_to_felt_string(196) == '196', 'wrong level for 196');
        assert(u16_to_felt_string(197) == '197', 'wrong level for 197');
        assert(u16_to_felt_string(198) == '198', 'wrong level for 198');
        assert(u16_to_felt_string(199) == '199', 'wrong level for 199');
        assert(u16_to_felt_string(200) == '200', 'wrong level for 200');
    }

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part5() {
        assert(u16_to_felt_string(201) == '201', 'wrong level for 201');
        assert(u16_to_felt_string(202) == '202', 'wrong level for 202');
        assert(u16_to_felt_string(203) == '203', 'wrong level for 203');
        assert(u16_to_felt_string(204) == '204', 'wrong level for 204');
        assert(u16_to_felt_string(205) == '205', 'wrong level for 205');
        assert(u16_to_felt_string(206) == '206', 'wrong level for 206');
        assert(u16_to_felt_string(207) == '207', 'wrong level for 207');
        assert(u16_to_felt_string(208) == '208', 'wrong level for 208');
        assert(u16_to_felt_string(209) == '209', 'wrong level for 209');
        assert(u16_to_felt_string(210) == '210', 'wrong level for 210');
        assert(u16_to_felt_string(211) == '211', 'wrong level for 211');
        assert(u16_to_felt_string(212) == '212', 'wrong level for 212');
        assert(u16_to_felt_string(213) == '213', 'wrong level for 213');
        assert(u16_to_felt_string(214) == '214', 'wrong level for 214');
        assert(u16_to_felt_string(215) == '215', 'wrong level for 215');
        assert(u16_to_felt_string(216) == '216', 'wrong level for 216');
        assert(u16_to_felt_string(217) == '217', 'wrong level for 217');
        assert(u16_to_felt_string(218) == '218', 'wrong level for 218');
        assert(u16_to_felt_string(219) == '219', 'wrong level for 219');
        assert(u16_to_felt_string(220) == '220', 'wrong level for 220');
        assert(u16_to_felt_string(221) == '221', 'wrong level for 221');
        assert(u16_to_felt_string(222) == '222', 'wrong level for 222');
        assert(u16_to_felt_string(223) == '223', 'wrong level for 223');
        assert(u16_to_felt_string(224) == '224', 'wrong level for 224');
        assert(u16_to_felt_string(225) == '225', 'wrong level for 225');
        assert(u16_to_felt_string(226) == '226', 'wrong level for 226');
        assert(u16_to_felt_string(227) == '227', 'wrong level for 227');
        assert(u16_to_felt_string(228) == '228', 'wrong level for 228');
        assert(u16_to_felt_string(229) == '229', 'wrong level for 229');
        assert(u16_to_felt_string(230) == '230', 'wrong level for 230');
        assert(u16_to_felt_string(231) == '231', 'wrong level for 231');
        assert(u16_to_felt_string(232) == '232', 'wrong level for 232');
        assert(u16_to_felt_string(233) == '233', 'wrong level for 233');
        assert(u16_to_felt_string(234) == '234', 'wrong level for 234');
        assert(u16_to_felt_string(235) == '235', 'wrong level for 235');
        assert(u16_to_felt_string(236) == '236', 'wrong level for 236');
        assert(u16_to_felt_string(237) == '237', 'wrong level for 237');
        assert(u16_to_felt_string(238) == '238', 'wrong level for 238');
        assert(u16_to_felt_string(239) == '239', 'wrong level for 239');
        assert(u16_to_felt_string(240) == '240', 'wrong level for 240');
        assert(u16_to_felt_string(241) == '241', 'wrong level for 241');
        assert(u16_to_felt_string(242) == '242', 'wrong level for 242');
        assert(u16_to_felt_string(243) == '243', 'wrong level for 243');
        assert(u16_to_felt_string(244) == '244', 'wrong level for 244');
        assert(u16_to_felt_string(245) == '245', 'wrong level for 245');
        assert(u16_to_felt_string(246) == '246', 'wrong level for 246');
        assert(u16_to_felt_string(247) == '247', 'wrong level for 247');
        assert(u16_to_felt_string(248) == '248', 'wrong level for 248');
        assert(u16_to_felt_string(249) == '249', 'wrong level for 249');
        assert(u16_to_felt_string(250) == '250', 'wrong level for 250');
    }

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part6() {
        assert(u16_to_felt_string(251) == '251', 'wrong level for 251');
        assert(u16_to_felt_string(252) == '252', 'wrong level for 252');
        assert(u16_to_felt_string(253) == '253', 'wrong level for 253');
        assert(u16_to_felt_string(254) == '254', 'wrong level for 254');
        assert(u16_to_felt_string(255) == '255', 'wrong level for 255');
        assert(u16_to_felt_string(256) == '256', 'wrong level for 256');
        assert(u16_to_felt_string(257) == '257', 'wrong level for 257');
        assert(u16_to_felt_string(258) == '258', 'wrong level for 258');
        assert(u16_to_felt_string(259) == '259', 'wrong level for 259');
        assert(u16_to_felt_string(260) == '260', 'wrong level for 260');
        assert(u16_to_felt_string(261) == '261', 'wrong level for 261');
        assert(u16_to_felt_string(262) == '262', 'wrong level for 262');
        assert(u16_to_felt_string(263) == '263', 'wrong level for 263');
        assert(u16_to_felt_string(264) == '264', 'wrong level for 264');
        assert(u16_to_felt_string(265) == '265', 'wrong level for 265');
        assert(u16_to_felt_string(266) == '266', 'wrong level for 266');
        assert(u16_to_felt_string(267) == '267', 'wrong level for 267');
        assert(u16_to_felt_string(268) == '268', 'wrong level for 268');
        assert(u16_to_felt_string(269) == '269', 'wrong level for 269');
        assert(u16_to_felt_string(270) == '270', 'wrong level for 270');
        assert(u16_to_felt_string(271) == '271', 'wrong level for 271');
        assert(u16_to_felt_string(272) == '272', 'wrong level for 272');
        assert(u16_to_felt_string(273) == '273', 'wrong level for 273');
        assert(u16_to_felt_string(274) == '274', 'wrong level for 274');
        assert(u16_to_felt_string(275) == '275', 'wrong level for 275');
        assert(u16_to_felt_string(276) == '276', 'wrong level for 276');
        assert(u16_to_felt_string(277) == '277', 'wrong level for 277');
        assert(u16_to_felt_string(278) == '278', 'wrong level for 278');
        assert(u16_to_felt_string(279) == '279', 'wrong level for 279');
        assert(u16_to_felt_string(280) == '280', 'wrong level for 280');
        assert(u16_to_felt_string(281) == '281', 'wrong level for 281');
        assert(u16_to_felt_string(282) == '282', 'wrong level for 282');
        assert(u16_to_felt_string(283) == '283', 'wrong level for 283');
        assert(u16_to_felt_string(284) == '284', 'wrong level for 284');
        assert(u16_to_felt_string(285) == '285', 'wrong level for 285');
        assert(u16_to_felt_string(286) == '286', 'wrong level for 286');
        assert(u16_to_felt_string(287) == '287', 'wrong level for 287');
        assert(u16_to_felt_string(288) == '288', 'wrong level for 288');
        assert(u16_to_felt_string(289) == '289', 'wrong level for 289');
        assert(u16_to_felt_string(290) == '290', 'wrong level for 290');
        assert(u16_to_felt_string(291) == '291', 'wrong level for 291');
        assert(u16_to_felt_string(292) == '292', 'wrong level for 292');
        assert(u16_to_felt_string(293) == '293', 'wrong level for 293');
        assert(u16_to_felt_string(294) == '294', 'wrong level for 294');
        assert(u16_to_felt_string(295) == '295', 'wrong level for 295');
        assert(u16_to_felt_string(296) == '296', 'wrong level for 296');
        assert(u16_to_felt_string(297) == '297', 'wrong level for 297');
        assert(u16_to_felt_string(298) == '298', 'wrong level for 298');
        assert(u16_to_felt_string(299) == '299', 'wrong level for 299');
        assert(u16_to_felt_string(300) == '300', 'wrong level for 300');
    }

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part7() {
        assert(u16_to_felt_string(301) == '301', 'wrong level for 301');
        assert(u16_to_felt_string(302) == '302', 'wrong level for 302');
        assert(u16_to_felt_string(303) == '303', 'wrong level for 303');
        assert(u16_to_felt_string(304) == '304', 'wrong level for 304');
        assert(u16_to_felt_string(305) == '305', 'wrong level for 305');
        assert(u16_to_felt_string(306) == '306', 'wrong level for 306');
        assert(u16_to_felt_string(307) == '307', 'wrong level for 307');
        assert(u16_to_felt_string(308) == '308', 'wrong level for 308');
        assert(u16_to_felt_string(309) == '309', 'wrong level for 309');
        assert(u16_to_felt_string(310) == '310', 'wrong level for 310');
        assert(u16_to_felt_string(311) == '311', 'wrong level for 311');
        assert(u16_to_felt_string(312) == '312', 'wrong level for 312');
        assert(u16_to_felt_string(313) == '313', 'wrong level for 313');
        assert(u16_to_felt_string(314) == '314', 'wrong level for 314');
        assert(u16_to_felt_string(315) == '315', 'wrong level for 315');
        assert(u16_to_felt_string(316) == '316', 'wrong level for 316');
        assert(u16_to_felt_string(317) == '317', 'wrong level for 317');
        assert(u16_to_felt_string(318) == '318', 'wrong level for 318');
        assert(u16_to_felt_string(319) == '319', 'wrong level for 319');
        assert(u16_to_felt_string(320) == '320', 'wrong level for 320');
        assert(u16_to_felt_string(321) == '321', 'wrong level for 321');
        assert(u16_to_felt_string(322) == '322', 'wrong level for 322');
        assert(u16_to_felt_string(323) == '323', 'wrong level for 323');
        assert(u16_to_felt_string(324) == '324', 'wrong level for 324');
        assert(u16_to_felt_string(325) == '325', 'wrong level for 325');
        assert(u16_to_felt_string(326) == '326', 'wrong level for 326');
        assert(u16_to_felt_string(327) == '327', 'wrong level for 327');
        assert(u16_to_felt_string(328) == '328', 'wrong level for 328');
        assert(u16_to_felt_string(329) == '329', 'wrong level for 329');
        assert(u16_to_felt_string(330) == '330', 'wrong level for 330');
        assert(u16_to_felt_string(331) == '331', 'wrong level for 331');
        assert(u16_to_felt_string(332) == '332', 'wrong level for 332');
        assert(u16_to_felt_string(333) == '333', 'wrong level for 333');
        assert(u16_to_felt_string(334) == '334', 'wrong level for 334');
        assert(u16_to_felt_string(335) == '335', 'wrong level for 335');
        assert(u16_to_felt_string(336) == '336', 'wrong level for 336');
        assert(u16_to_felt_string(337) == '337', 'wrong level for 337');
        assert(u16_to_felt_string(338) == '338', 'wrong level for 338');
        assert(u16_to_felt_string(339) == '339', 'wrong level for 339');
        assert(u16_to_felt_string(340) == '340', 'wrong level for 340');
        assert(u16_to_felt_string(341) == '341', 'wrong level for 341');
        assert(u16_to_felt_string(342) == '342', 'wrong level for 342');
        assert(u16_to_felt_string(343) == '343', 'wrong level for 343');
        assert(u16_to_felt_string(344) == '344', 'wrong level for 344');
        assert(u16_to_felt_string(345) == '345', 'wrong level for 345');
        assert(u16_to_felt_string(346) == '346', 'wrong level for 346');
        assert(u16_to_felt_string(347) == '347', 'wrong level for 347');
        assert(u16_to_felt_string(348) == '348', 'wrong level for 348');
        assert(u16_to_felt_string(349) == '349', 'wrong level for 349');
        assert(u16_to_felt_string(350) == '350', 'wrong level for 350');
    }

    #[test]
    #[available_gas(2265600000000)]
    fn test_u16_to_felt_string_part8() {
        assert(u16_to_felt_string(351) == '351', 'wrong level for 351');
        assert(u16_to_felt_string(352) == '352', 'wrong level for 352');
        assert(u16_to_felt_string(353) == '353', 'wrong level for 353');
        assert(u16_to_felt_string(354) == '354', 'wrong level for 354');
        assert(u16_to_felt_string(355) == '355', 'wrong level for 355');
        assert(u16_to_felt_string(356) == '356', 'wrong level for 356');
        assert(u16_to_felt_string(357) == '357', 'wrong level for 357');
        assert(u16_to_felt_string(358) == '358', 'wrong level for 358');
        assert(u16_to_felt_string(359) == '359', 'wrong level for 359');
        assert(u16_to_felt_string(360) == '360', 'wrong level for 360');
        assert(u16_to_felt_string(361) == '361', 'wrong level for 361');
        assert(u16_to_felt_string(362) == '362', 'wrong level for 362');
        assert(u16_to_felt_string(363) == '363', 'wrong level for 363');
        assert(u16_to_felt_string(364) == '364', 'wrong level for 364');
        assert(u16_to_felt_string(365) == '365', 'wrong level for 365');
        assert(u16_to_felt_string(366) == '366', 'wrong level for 366');
        assert(u16_to_felt_string(367) == '367', 'wrong level for 367');
        assert(u16_to_felt_string(368) == '368', 'wrong level for 368');
        assert(u16_to_felt_string(369) == '369', 'wrong level for 369');
        assert(u16_to_felt_string(370) == '370', 'wrong level for 370');
        assert(u16_to_felt_string(371) == '371', 'wrong level for 371');
        assert(u16_to_felt_string(372) == '372', 'wrong level for 372');
        assert(u16_to_felt_string(373) == '373', 'wrong level for 373');
        assert(u16_to_felt_string(374) == '374', 'wrong level for 374');
        assert(u16_to_felt_string(375) == '375', 'wrong level for 375');
        assert(u16_to_felt_string(376) == '376', 'wrong level for 376');
        assert(u16_to_felt_string(377) == '377', 'wrong level for 377');
        assert(u16_to_felt_string(378) == '378', 'wrong level for 378');
        assert(u16_to_felt_string(379) == '379', 'wrong level for 379');
        assert(u16_to_felt_string(380) == '380', 'wrong level for 380');
        assert(u16_to_felt_string(381) == '381', 'wrong level for 381');
        assert(u16_to_felt_string(382) == '382', 'wrong level for 382');
        assert(u16_to_felt_string(383) == '383', 'wrong level for 383');
        assert(u16_to_felt_string(384) == '384', 'wrong level for 384');
        assert(u16_to_felt_string(385) == '385', 'wrong level for 385');
        assert(u16_to_felt_string(386) == '386', 'wrong level for 386');
        assert(u16_to_felt_string(387) == '387', 'wrong level for 387');
        assert(u16_to_felt_string(388) == '388', 'wrong level for 388');
        assert(u16_to_felt_string(389) == '389', 'wrong level for 389');
        assert(u16_to_felt_string(390) == '390', 'wrong level for 390');
        assert(u16_to_felt_string(391) == '391', 'wrong level for 391');
        assert(u16_to_felt_string(392) == '392', 'wrong level for 392');
        assert(u16_to_felt_string(393) == '393', 'wrong level for 393');
        assert(u16_to_felt_string(394) == '394', 'wrong level for 394');
        assert(u16_to_felt_string(395) == '395', 'wrong level for 395');
        assert(u16_to_felt_string(396) == '396', 'wrong level for 396');
        assert(u16_to_felt_string(397) == '397', 'wrong level for 397');
        assert(u16_to_felt_string(398) == '398', 'wrong level for 398');
        assert(u16_to_felt_string(399) == '399', 'wrong level for 399');
    }

    #[test]
    #[available_gas(22656000000)]
    fn test_u16_to_felt_string_part9() {
        assert(u16_to_felt_string(400) == '400', 'wrong level for 400');
        assert(u16_to_felt_string(401) == '401', 'wrong level for 401');
        assert(u16_to_felt_string(402) == '402', 'wrong level for 402');
        assert(u16_to_felt_string(403) == '403', 'wrong level for 403');
        assert(u16_to_felt_string(404) == '404', 'wrong level for 404');
        assert(u16_to_felt_string(405) == '405', 'wrong level for 405');
        assert(u16_to_felt_string(406) == '406', 'wrong level for 406');
        assert(u16_to_felt_string(407) == '407', 'wrong level for 407');
        assert(u16_to_felt_string(408) == '408', 'wrong level for 408');
        assert(u16_to_felt_string(409) == '409', 'wrong level for 409');
        assert(u16_to_felt_string(410) == '410', 'wrong level for 410');
        assert(u16_to_felt_string(411) == '411', 'wrong level for 411');
        assert(u16_to_felt_string(412) == '412', 'wrong level for 412');
        assert(u16_to_felt_string(413) == '413', 'wrong level for 413');
        assert(u16_to_felt_string(414) == '414', 'wrong level for 414');
        assert(u16_to_felt_string(415) == '415', 'wrong level for 415');
        assert(u16_to_felt_string(416) == '416', 'wrong level for 416');
        assert(u16_to_felt_string(417) == '417', 'wrong level for 417');
        assert(u16_to_felt_string(418) == '418', 'wrong level for 418');
        assert(u16_to_felt_string(419) == '419', 'wrong level for 419');
        assert(u16_to_felt_string(420) == '420', 'wrong level for 420');
        assert(u16_to_felt_string(421) == '421', 'wrong level for 421');
        assert(u16_to_felt_string(422) == '422', 'wrong level for 422');
        assert(u16_to_felt_string(423) == '423', 'wrong level for 423');
        assert(u16_to_felt_string(424) == '424', 'wrong level for 424');
        assert(u16_to_felt_string(425) == '425', 'wrong level for 425');
        assert(u16_to_felt_string(426) == '426', 'wrong level for 426');
        assert(u16_to_felt_string(427) == '427', 'wrong level for 427');
        assert(u16_to_felt_string(428) == '428', 'wrong level for 428');
        assert(u16_to_felt_string(429) == '429', 'wrong level for 429');
        assert(u16_to_felt_string(430) == '430', 'wrong level for 430');
        assert(u16_to_felt_string(431) == '431', 'wrong level for 431');
        assert(u16_to_felt_string(432) == '432', 'wrong level for 432');
        assert(u16_to_felt_string(433) == '433', 'wrong level for 433');
        assert(u16_to_felt_string(434) == '434', 'wrong level for 434');
        assert(u16_to_felt_string(435) == '435', 'wrong level for 435');
        assert(u16_to_felt_string(436) == '436', 'wrong level for 436');
        assert(u16_to_felt_string(437) == '437', 'wrong level for 437');
        assert(u16_to_felt_string(438) == '438', 'wrong level for 438');
        assert(u16_to_felt_string(439) == '439', 'wrong level for 439');
        assert(u16_to_felt_string(440) == '440', 'wrong level for 440');
        assert(u16_to_felt_string(441) == '441', 'wrong level for 441');
        assert(u16_to_felt_string(442) == '442', 'wrong level for 442');
        assert(u16_to_felt_string(443) == '443', 'wrong level for 443');
        assert(u16_to_felt_string(444) == '444', 'wrong level for 444');
        assert(u16_to_felt_string(445) == '445', 'wrong level for 445');
        assert(u16_to_felt_string(446) == '446', 'wrong level for 446');
        assert(u16_to_felt_string(447) == '447', 'wrong level for 447');
        assert(u16_to_felt_string(448) == '448', 'wrong level for 448');
        assert(u16_to_felt_string(449) == '449', 'wrong level for 449');
        assert(u16_to_felt_string(450) == '450', 'wrong level for 450');
    }

    #[test]
    #[available_gas(22656000000)]
    fn test_u16_to_felt_string_part10() {
        assert(u16_to_felt_string(451) == '451', 'wrong level for 451');
        assert(u16_to_felt_string(452) == '452', 'wrong level for 452');
        assert(u16_to_felt_string(453) == '453', 'wrong level for 453');
        assert(u16_to_felt_string(454) == '454', 'wrong level for 454');
        assert(u16_to_felt_string(455) == '455', 'wrong level for 455');
        assert(u16_to_felt_string(456) == '456', 'wrong level for 456');
        assert(u16_to_felt_string(457) == '457', 'wrong level for 457');
        assert(u16_to_felt_string(458) == '458', 'wrong level for 458');
        assert(u16_to_felt_string(459) == '459', 'wrong level for 459');
        assert(u16_to_felt_string(460) == '460', 'wrong level for 460');
        assert(u16_to_felt_string(461) == '461', 'wrong level for 461');
        assert(u16_to_felt_string(462) == '462', 'wrong level for 462');
        assert(u16_to_felt_string(463) == '463', 'wrong level for 463');
        assert(u16_to_felt_string(464) == '464', 'wrong level for 464');
        assert(u16_to_felt_string(465) == '465', 'wrong level for 465');
        assert(u16_to_felt_string(466) == '466', 'wrong level for 466');
        assert(u16_to_felt_string(467) == '467', 'wrong level for 467');
        assert(u16_to_felt_string(468) == '468', 'wrong level for 468');
        assert(u16_to_felt_string(469) == '469', 'wrong level for 469');
        assert(u16_to_felt_string(470) == '470', 'wrong level for 470');
        assert(u16_to_felt_string(471) == '471', 'wrong level for 471');
        assert(u16_to_felt_string(472) == '472', 'wrong level for 472');
        assert(u16_to_felt_string(473) == '473', 'wrong level for 473');
        assert(u16_to_felt_string(474) == '474', 'wrong level for 474');
        assert(u16_to_felt_string(475) == '475', 'wrong level for 475');
        assert(u16_to_felt_string(476) == '476', 'wrong level for 476');
        assert(u16_to_felt_string(477) == '477', 'wrong level for 477');
        assert(u16_to_felt_string(478) == '478', 'wrong level for 478');
        assert(u16_to_felt_string(479) == '479', 'wrong level for 479');
        assert(u16_to_felt_string(480) == '480', 'wrong level for 480');
        assert(u16_to_felt_string(481) == '481', 'wrong level for 481');
        assert(u16_to_felt_string(482) == '482', 'wrong level for 482');
        assert(u16_to_felt_string(483) == '483', 'wrong level for 483');
        assert(u16_to_felt_string(484) == '484', 'wrong level for 484');
        assert(u16_to_felt_string(485) == '485', 'wrong level for 485');
        assert(u16_to_felt_string(486) == '486', 'wrong level for 486');
        assert(u16_to_felt_string(487) == '487', 'wrong level for 487');
        assert(u16_to_felt_string(488) == '488', 'wrong level for 488');
        assert(u16_to_felt_string(489) == '489', 'wrong level for 489');
        assert(u16_to_felt_string(490) == '490', 'wrong level for 490');
        assert(u16_to_felt_string(491) == '491', 'wrong level for 491');
        assert(u16_to_felt_string(492) == '492', 'wrong level for 492');
        assert(u16_to_felt_string(493) == '493', 'wrong level for 493');
        assert(u16_to_felt_string(494) == '494', 'wrong level for 494');
        assert(u16_to_felt_string(495) == '495', 'wrong level for 495');
        assert(u16_to_felt_string(496) == '496', 'wrong level for 496');
        assert(u16_to_felt_string(497) == '497', 'wrong level for 497');
        assert(u16_to_felt_string(498) == '498', 'wrong level for 498');
        assert(u16_to_felt_string(499) == '499', 'wrong level for 499');
        assert(u16_to_felt_string(500) == '500', 'wrong level for 500');
    }

    #[test]
    #[available_gas(22656000000)]
    fn test_u16_to_felt_string_part11() {
        assert(u16_to_felt_string(501) == '501', 'wrong level for 501');
        assert(u16_to_felt_string(502) == '502', 'wrong level for 502');
        assert(u16_to_felt_string(503) == '503', 'wrong level for 503');
        assert(u16_to_felt_string(504) == '504', 'wrong level for 504');
        assert(u16_to_felt_string(505) == '505', 'wrong level for 505');
        assert(u16_to_felt_string(506) == '506', 'wrong level for 506');
        assert(u16_to_felt_string(507) == '507', 'wrong level for 507');
        assert(u16_to_felt_string(508) == '508', 'wrong level for 508');
        assert(u16_to_felt_string(509) == '509', 'wrong level for 509');
        assert(u16_to_felt_string(510) == '510', 'wrong level for 510');
        assert(u16_to_felt_string(511) == '511', 'wrong level for 511');

        // 511 is max so anything beyond should be 511
        assert(u16_to_felt_string(512) == '511', 'wrong level for 512');
    }

    #[test]
    fn test_get_content() {
        let beast = PackableBeast { id: 1, prefix: 1, suffix: 1, level: 1, health: 1 };

        let content = get_content(beast);
        let mut i = 0;
        loop {
            if i >= content.len() {
                break;
            }
            let segment = *content.at(i);
            // Uncomment to view content
            println!("Segment: {:?}", segment);
            i += 1;
        }
    }

    #[test]
    #[available_gas(25360)]
    fn test_get_type_gas() {
        get_type(1);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast',))]
    #[available_gas(4310)]
    fn test_get_type_zero() {
        get_type(0);
    }

    #[test]
    #[should_panic(expected: ('Invalid beast',))]
    #[available_gas(4310)]
    fn test_get_type_out_of_bounds() {
        get_type(76);
    }

    #[test]
    #[available_gas(308950)]
    fn test_get_type() {
        // Magical T1s
        assert(get_type(WARLOCK) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(TYPHON) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(JIANGSHI) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(ANANSI) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(BASILISK) == TYPE_MAGICAL, 'should be magic');

        // Magical T2s
        assert(get_type(GORGON) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(KITSUNE) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(LICH) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(CHIMERA) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(WENDIGO) == TYPE_MAGICAL, 'should be magic');

        // Magical T3s
        assert(get_type(RAKSHASA) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(WEREWOLF) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(BANSHEE) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(DRAUGR) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(VAMPIRE) == TYPE_MAGICAL, 'should be magic');

        // Magical T4s
        assert(get_type(GOBLIN) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(GHOUL) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(WRAITH) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(SPRITE) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(KAPPA) == TYPE_MAGICAL, 'should be magic');

        // Magical T5s
        assert(get_type(FAIRY) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(LEPRECHAUN) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(KELPIE) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(PIXIE) == TYPE_MAGICAL, 'should be magic');
        assert(get_type(GNOME) == TYPE_MAGICAL, 'should be magic');

        // Hunter T1s
        assert(get_type(GRIFFIN) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(MANTICORE) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(PHOENIX) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(DRAGON) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(MINOTAUR) == TYPE_HUNTER, 'should be hunter');

        // Hunter T2s
        assert(get_type(QILIN) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(AMMIT) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(NUE) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(SKINWALKER) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(CHUPACABRA) == TYPE_HUNTER, 'should be hunter');

        // Hunter T3s
        assert(get_type(WERETIGER) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(WYVERN) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(ROC) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(HARPY) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(PEGASUS) == TYPE_HUNTER, 'should be hunter');

        // Hunter T4s
        assert(get_type(HIPPOGRIFF) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(FENRIR) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(JAGUAR) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(SATORI) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(DIREWOLF) == TYPE_HUNTER, 'should be hunter');

        // Hunter T5s
        assert(get_type(BEAR) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(WOLF) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(MANTIS) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(SPIDER) == TYPE_HUNTER, 'should be hunter');
        assert(get_type(RAT) == TYPE_HUNTER, 'should be hunter');

        // Brute T1s
        assert(get_type(KRAKEN) == TYPE_BRUTE, 'should be beast');
        assert(get_type(COLOSSUS) == TYPE_BRUTE, 'should be beast');
        assert(get_type(BALROG) == TYPE_BRUTE, 'should be beast');
        assert(get_type(LEVIATHAN) == TYPE_BRUTE, 'should be beast');
        assert(get_type(TARRASQUE) == TYPE_BRUTE, 'should be beast');

        // Brute T2s
        assert(get_type(TITAN) == TYPE_BRUTE, 'should be beast');
        assert(get_type(NEPHILIM) == TYPE_BRUTE, 'should be beast');
        assert(get_type(BEHEMOTH) == TYPE_BRUTE, 'should be beast');
        assert(get_type(HYDRA) == TYPE_BRUTE, 'should be beast');
        assert(get_type(JUGGERNAUT) == TYPE_BRUTE, 'should be beast');

        // Brute T3s
        assert(get_type(ONI) == TYPE_BRUTE, 'should be beast');
        assert(get_type(JOTUNN) == TYPE_BRUTE, 'should be beast');
        assert(get_type(ETTIN) == TYPE_BRUTE, 'should be beast');
        assert(get_type(CYCLOPS) == TYPE_BRUTE, 'should be beast');
        assert(get_type(GIANT) == TYPE_BRUTE, 'should be beast');

        // Brute T4s
        assert(get_type(NEMEANLION) == TYPE_BRUTE, 'should be beast');
        assert(get_type(BERSERKER) == TYPE_BRUTE, 'should be beast');
        assert(get_type(YETI) == TYPE_BRUTE, 'should be beast');
        assert(get_type(GOLEM) == TYPE_BRUTE, 'should be beast');
        assert(get_type(ENT) == TYPE_BRUTE, 'should be beast');

        // Brute T5s
        assert(get_type(TROLL) == TYPE_BRUTE, 'should be beast');
        assert(get_type(BIGFOOT) == TYPE_BRUTE, 'should be beast');
        assert(get_type(OGRE) == TYPE_BRUTE, 'should be beast');
        assert(get_type(ORC) == TYPE_BRUTE, 'should be beast');
        assert(get_type(SKELETON) == TYPE_BRUTE, 'should be beast');
    }

    #[test]
    #[available_gas(21430)]
    fn test_get_tier_gas() {
        get_tier(1);
    }

    #[test]
    #[available_gas(21430)]
    #[should_panic(expected: ('Invalid beast',))]
    fn test_get_tier_zero() {
        get_tier(0);
    }

    #[test]
    #[available_gas(21430)]
    #[should_panic(expected: ('Invalid beast',))]
    fn test_get_tier_out_of_bounds() {
        get_tier(76);
    }

    #[test]
    #[available_gas(1592950)]
    fn test_get_tier() {
        // Test for Magical T1s
        assert(get_tier(WARLOCK) == '1', 'Warlock should be T1');
        assert(get_tier(TYPHON) == '1', 'Typhon should be T1');
        assert(get_tier(JIANGSHI) == '1', 'Jiangshi should be T1');
        assert(get_tier(ANANSI) == '1', 'Anansi should be T1');
        assert(get_tier(BASILISK) == '1', 'Basilisk should be T1');

        // Test for Magical T2s
        assert(get_tier(GORGON) == '2', 'Gorgon should be T2');
        assert(get_tier(KITSUNE) == '2', 'Kitsune should be T2');
        assert(get_tier(LICH) == '2', 'Lich should be T2');
        assert(get_tier(CHIMERA) == '2', 'Chimera should be T2');
        assert(get_tier(WENDIGO) == '2', 'Wendigo should be T2');

        // Test for Magical T3s
        assert(get_tier(RAKSHASA) == '3', 'Rakshasa should be T3');
        assert(get_tier(WEREWOLF) == '3', 'Werewolf should be T3');
        assert(get_tier(BANSHEE) == '3', 'Banshee should be T3');
        assert(get_tier(DRAUGR) == '3', 'Draugr should be T3');
        assert(get_tier(VAMPIRE) == '3', 'Vampire should be T3');

        // Test for Magical T4s
        assert(get_tier(GOBLIN) == '4', 'Goblin should be T4');
        assert(get_tier(GHOUL) == '4', 'Ghoul should be T4');
        assert(get_tier(WRAITH) == '4', 'Wraith should be T4');
        assert(get_tier(SPRITE) == '4', 'Sprite should be T4');
        assert(get_tier(KAPPA) == '4', 'Kappa should be T4');

        // Test for Magical T5s
        assert(get_tier(FAIRY) == '5', 'Fairy should be T5');
        assert(get_tier(LEPRECHAUN) == '5', 'Leprechaun should be T5');
        assert(get_tier(KELPIE) == '5', 'Kelpie should be T5');
        assert(get_tier(PIXIE) == '5', 'Pixie should be T5');
        assert(get_tier(GNOME) == '5', 'Gnome should be T5');

        // Test for Hunter T1s
        assert(get_tier(GRIFFIN) == '1', 'Griffin should be T1');
        assert(get_tier(MANTICORE) == '1', 'Manticore should be T1');
        assert(get_tier(PHOENIX) == '1', 'Phoenix should be T1');
        assert(get_tier(DRAGON) == '1', 'Dragon should be T1');
        assert(get_tier(MINOTAUR) == '1', 'Minotaur should be T1');

        // Test for Hunter T2s
        assert(get_tier(QILIN) == '2', 'Qilin should be T2');
        assert(get_tier(AMMIT) == '2', 'Ammit should be T2');
        assert(get_tier(NUE) == '2', 'Nue should be T2');
        assert(get_tier(SKINWALKER) == '2', 'Skinwalker should be T2');
        assert(get_tier(CHUPACABRA) == '2', 'Chupacabra should be T2');

        // Test for Hunter T3s
        assert(get_tier(WERETIGER) == '3', 'Weretiger should be T3');
        assert(get_tier(WYVERN) == '3', 'Wyvern should be T3');
        assert(get_tier(ROC) == '3', 'Roc should be T3');
        assert(get_tier(HARPY) == '3', 'Harpy should be T3');
        assert(get_tier(PEGASUS) == '3', 'Pegasus should be T3');

        // Test for Hunter T4s
        assert(get_tier(HIPPOGRIFF) == '4', 'Hippogriff should be T4');
        assert(get_tier(FENRIR) == '4', 'Fenrir should be T4');
        assert(get_tier(JAGUAR) == '4', 'Jaguar should be T4');
        assert(get_tier(SATORI) == '4', 'Satori should be T4');
        assert(get_tier(DIREWOLF) == '4', 'Direwolf should be T4');

        // Test for Hunter T5s
        assert(get_tier(BEAR) == '5', 'Bear should be T5');
        assert(get_tier(WOLF) == '5', 'Wolf should be T5');
        assert(get_tier(MANTIS) == '5', 'Mantis should be T5');
        assert(get_tier(SPIDER) == '5', 'Spider should be T5');
        assert(get_tier(RAT) == '5', 'Rat should be T5');

        // Test for Brute T1s
        assert(get_tier(KRAKEN) == '1', 'Kraken should be T1');
        assert(get_tier(COLOSSUS) == '1', 'Colossus should be T1');
        assert(get_tier(BALROG) == '1', 'Balrog should be T1');
        assert(get_tier(LEVIATHAN) == '1', 'Leviathan should be T1');
        assert(get_tier(TARRASQUE) == '1', 'Tarrasque should be T1');

        // Test for Brute T2s
        assert(get_tier(TITAN) == '2', 'Titan should be T2');
        assert(get_tier(NEPHILIM) == '2', 'Nephilim should be T2');
        assert(get_tier(BEHEMOTH) == '2', 'Behemoth should be T2');
        assert(get_tier(HYDRA) == '2', 'Hydra should be T2');
        assert(get_tier(JUGGERNAUT) == '2', 'Juggernaut should be T2');

        // Test for Brute T3s
        assert(get_tier(ONI) == '3', 'Oni should be T3');
        assert(get_tier(JOTUNN) == '3', 'Jotunn should be T3');
        assert(get_tier(ETTIN) == '3', 'Ettin should be T3');
        assert(get_tier(CYCLOPS) == '3', 'Cyclops should be T3');
        assert(get_tier(GIANT) == '3', 'Minogon should be T3');

        // Test for Brute T4s
        assert(get_tier(NEMEANLION) == '4', 'Zombie should be T4');
        assert(get_tier(BERSERKER) == '4', 'Golem should be T4');
        assert(get_tier(YETI) == '4', 'Yeti should be T4');
        assert(get_tier(GOLEM) == '4', 'Mummy should be T4');
        assert(get_tier(ENT) == '4', 'Doppelganger should be T4');

        // Test for Brute T5s
        assert(get_tier(TROLL) == '5', 'Troll should be T5');
        assert(get_tier(BIGFOOT) == '5', 'Bigfoot should be T5');
        assert(get_tier(OGRE) == '5', 'Ogre should be T5');
        assert(get_tier(ORC) == '5', 'Orc should be T5');
        assert(get_tier(SKELETON) == '5', 'Skeleton should be T5');
    }

    #[test]
    #[available_gas(300000)]
    fn test_get_svg_gas() {
        get_svg(1);
    }

    #[test]
    #[available_gas(30000)]
    #[should_panic(expected: ('Invalid beast',))]
    fn test_get_svg_zero() {
        get_svg(0);
    }

    #[test]
    #[available_gas(30000)]
    #[should_panic(expected: ('Invalid beast',))]
    fn test_get_svg_out_of_bounds() {
        get_svg(76);
    }

    #[test]
    #[available_gas(23710)]
    fn test_get_name_gas() {
        get_name(1);
    }

    #[test]
    #[available_gas(23710)]
    #[should_panic(expected: ('Invalid beast',))]
    fn test_get_name_out_of_bounds() {
        get_name(76);
    }

    #[test]
    #[available_gas(1771350)]
    fn test_get_name() {
        assert(get_name(WARLOCK) == 'Warlock', 'should be Warlock');
        assert(get_name(TYPHON) == 'Typhon', 'should be Typhon');
        assert(get_name(JIANGSHI) == 'Jiangshi', 'should be Jiangshi');
        assert(get_name(ANANSI) == 'Anansi', 'should be Anansi');
        assert(get_name(BASILISK) == 'Basilisk', 'should be Basilisk');

        assert(get_name(GORGON) == 'Gorgon', 'should be Gorgon');
        assert(get_name(KITSUNE) == 'Kitsune', 'should be Kitsune');
        assert(get_name(LICH) == 'Lich', 'should be Lich');
        assert(get_name(CHIMERA) == 'Chimera', 'should be Chimera');
        assert(get_name(WENDIGO) == 'Wendigo', 'should be Wendigo');

        assert(get_name(RAKSHASA) == 'Rakshasa', 'should be Rakshasa');
        assert(get_name(WEREWOLF) == 'Werewolf', 'should be Werewolf');
        assert(get_name(BANSHEE) == 'Banshee', 'should be Banshee');
        assert(get_name(DRAUGR) == 'Draugr', 'should be Draugr');
        assert(get_name(VAMPIRE) == 'Vampire', 'should be Vampire');

        assert(get_name(GOBLIN) == 'Goblin', 'should be Goblin');
        assert(get_name(GHOUL) == 'Ghoul', 'should be Ghoul');
        assert(get_name(WRAITH) == 'Wraith', 'should be Wraith');
        assert(get_name(SPRITE) == 'Sprite', 'should be Sprite');
        assert(get_name(KAPPA) == 'Kappa', 'should be Kappa');

        assert(get_name(FAIRY) == 'Fairy', 'should be Fairy');
        assert(get_name(LEPRECHAUN) == 'Leprechaun', 'should be Leprechaun');
        assert(get_name(KELPIE) == 'Kelpie', 'should be Kelpie');
        assert(get_name(PIXIE) == 'Pixie', 'should be Pixie');
        assert(get_name(GNOME) == 'Gnome', 'should be Gnome');

        assert(get_name(GRIFFIN) == 'Griffin', 'should be Griffin');
        assert(get_name(MANTICORE) == 'Manticore', 'should be Manticore');
        assert(get_name(PHOENIX) == 'Phoenix', 'should be Phoenix');
        assert(get_name(DRAGON) == 'Dragon', 'should be Dragon');
        assert(get_name(MINOTAUR) == 'Minotaur', 'should be Minotaur');

        assert(get_name(QILIN) == 'Qilin', 'should be Qilin');
        assert(get_name(AMMIT) == 'Ammit', 'should be Ammit');
        assert(get_name(NUE) == 'Nue', 'should be Nue');
        assert(get_name(SKINWALKER) == 'Skinwalker', 'should be Skinwalker');
        assert(get_name(CHUPACABRA) == 'Chupacabra', 'should be Chupacabra');

        assert(get_name(WERETIGER) == 'Weretiger', 'should be Weretiger');
        assert(get_name(WYVERN) == 'Wyvern', 'should be Wyvern');
        assert(get_name(ROC) == 'Roc', 'should be Roc');
        assert(get_name(HARPY) == 'Harpy', 'should be Harpy');
        assert(get_name(PEGASUS) == 'Pegasus', 'should be Pegasus');

        assert(get_name(HIPPOGRIFF) == 'Hippogriff', 'should be Hippogriff');
        assert(get_name(FENRIR) == 'Fenrir', 'should be Fenrir');
        assert(get_name(JAGUAR) == 'Jaguar', 'should be Jaguar');
        assert(get_name(SATORI) == 'Satori', 'should be Satori');
        assert(get_name(DIREWOLF) == 'DireWolf', 'should be Direwolf');

        assert(get_name(BEAR) == 'Bear', 'should be Bear');
        assert(get_name(WOLF) == 'Wolf', 'should be Wolf');
        assert(get_name(MANTIS) == 'Mantis', 'should be Mantis');
        assert(get_name(SPIDER) == 'Spider', 'should be Spider');
        assert(get_name(RAT) == 'Rat', 'should be Rat');

        assert(get_name(KRAKEN) == 'Kraken', 'should be Kraken');
        assert(get_name(COLOSSUS) == 'Colossus', 'should be Colossus');
        assert(get_name(BALROG) == 'Balrog', 'should be Balrog');
        assert(get_name(LEVIATHAN) == 'Leviathan', 'should be Leviathan');
        assert(get_name(TARRASQUE) == 'Tarrasque', 'should be Tarrasque');

        assert(get_name(TITAN) == 'Titan', 'should be Titan');
        assert(get_name(NEPHILIM) == 'Nephilim', 'should be Nephilim');
        assert(get_name(BEHEMOTH) == 'Behemoth', 'should be Behemoth');
        assert(get_name(HYDRA) == 'Hydra', 'should be Hydra');
        assert(get_name(JUGGERNAUT) == 'Juggernaut', 'should be Juggernaut');

        assert(get_name(ONI) == 'Oni', 'should be Oni');
        assert(get_name(JOTUNN) == 'Jotunn', 'should be Jotunn');
        assert(get_name(ETTIN) == 'Ettin', 'should be Ettin');
        assert(get_name(CYCLOPS) == 'Cyclops', 'should be Cyclops');
        assert(get_name(GIANT) == 'Giant', 'should be Giant');

        assert(get_name(NEMEANLION) == 'NemeanLion', 'should be Nemean Lion');
        assert(get_name(BERSERKER) == 'Berserker', 'should be Berserker');
        assert(get_name(YETI) == 'Yeti', 'should be Yeti');
        assert(get_name(GOLEM) == 'Golem', 'should be Golem');
        assert(get_name(ENT) == 'Ent', 'should be Ent');

        assert(get_name(TROLL) == 'Troll', 'should be Troll');
        assert(get_name(BIGFOOT) == 'Bigfoot', 'should be Bigfoot');
        assert(get_name(OGRE) == 'Ogre', 'should be Ogre');
        assert(get_name(ORC) == 'Orc', 'should be Orc');
        assert(get_name(SKELETON) == 'Skeleton', 'should be Skeleton');
    }

    #[test]
    #[available_gas(21910)]
    fn test_get_prefix_gas() {
        get_prefix(1);
    }

    #[test]
    #[available_gas(1505490)]
    fn test_get_prefix() {
        assert(get_prefix(1) == 'Agony', 'should be Agony');
        assert(get_prefix(2) == 'Apocalypse', 'should be Apocalypse');
        assert(get_prefix(3) == 'Armageddon', 'should be Armageddon');
        assert(get_prefix(4) == 'Beast', 'should be Beast');
        assert(get_prefix(5) == 'Behemoth', 'should be Behemoth');
        assert(get_prefix(6) == 'Blight', 'should be Blight');
        assert(get_prefix(7) == 'Blood', 'should be Blood');
        assert(get_prefix(8) == 'Bramble', 'should be Bramble');
        assert(get_prefix(9) == 'Brimstone', 'should be Brimstone');
        assert(get_prefix(10) == 'Brood', 'should be Brood');
        assert(get_prefix(11) == 'Carrion', 'should be Carrion');
        assert(get_prefix(12) == 'Cataclysm', 'should be Cataclysm');
        assert(get_prefix(13) == 'Chimeric', 'should be Chimeric');
        assert(get_prefix(14) == 'Corpse', 'should be Corpse');
        assert(get_prefix(15) == 'Corruption', 'should be Corruption');
        assert(get_prefix(16) == 'Damnation', 'should be Damnation');
        assert(get_prefix(17) == 'Death', 'should be Death');
        assert(get_prefix(18) == 'Demon', 'should be Demon');
        assert(get_prefix(19) == 'Dire', 'should be Dire');
        assert(get_prefix(20) == 'Dragon', 'should be Dragon');
        assert(get_prefix(21) == 'Dread', 'should be Dread');
        assert(get_prefix(22) == 'Doom', 'should be Doom');
        assert(get_prefix(23) == 'Dusk', 'should be Dusk');
        assert(get_prefix(24) == 'Eagle', 'should be Eagle');
        assert(get_prefix(25) == 'Empyrean', 'should be Empyrean');
        assert(get_prefix(26) == 'Fate', 'should be Fate');
        assert(get_prefix(27) == 'Foe', 'should be Foe');
        assert(get_prefix(28) == 'Gale', 'should be Gale');
        assert(get_prefix(29) == 'Ghoul', 'should be Ghoul');
        assert(get_prefix(30) == 'Gloom', 'should be Gloom');
        assert(get_prefix(31) == 'Glyph', 'should be Glyph');
        assert(get_prefix(32) == 'Golem', 'should be Golem');
        assert(get_prefix(33) == 'Grim', 'should be Grim');
        assert(get_prefix(34) == 'Hate', 'should be Hate');
        assert(get_prefix(35) == 'Havoc', 'should be Havoc');
        assert(get_prefix(36) == 'Honour', 'should be Honour');
        assert(get_prefix(37) == 'Horror', 'should be Horror');
        assert(get_prefix(38) == 'Hypnotic', 'should be Hypnotic');
        assert(get_prefix(39) == 'Kraken', 'should be Kraken');
        assert(get_prefix(40) == 'Loath', 'should be Loath');
        assert(get_prefix(41) == 'Maelstrom', 'should be Maelstrom');
        assert(get_prefix(42) == 'Mind', 'should be Mind');
        assert(get_prefix(43) == 'Miracle', 'should be Miracle');
        assert(get_prefix(44) == 'Morbid', 'should be Morbid');
        assert(get_prefix(45) == 'Oblivion', 'should be Oblivion');
        assert(get_prefix(46) == 'Onslaught', 'should be Onslaught');
        assert(get_prefix(47) == 'Pain', 'should be Pain');
        assert(get_prefix(48) == 'Pandemonium', 'should be Pandemonium');
        assert(get_prefix(49) == 'Phoenix', 'should be Phoenix');
        assert(get_prefix(50) == 'Plague', 'should be Plague');
        assert(get_prefix(51) == 'Rage', 'should be Rage');
        assert(get_prefix(52) == 'Rapture', 'should be Rapture');
        assert(get_prefix(53) == 'Rune', 'should be Rune');
        assert(get_prefix(54) == 'Skull', 'should be Skull');
        assert(get_prefix(55) == 'Sol', 'should be Sol');
        assert(get_prefix(56) == 'Soul', 'should be Soul');
        assert(get_prefix(57) == 'Sorrow', 'should be Sorrow');
        assert(get_prefix(58) == 'Spirit', 'should be Spirit');
        assert(get_prefix(59) == 'Storm', 'should be Storm');
        assert(get_prefix(60) == 'Tempest', 'should be Tempest');
        assert(get_prefix(61) == 'Torment', 'should be Torment');
        assert(get_prefix(62) == 'Vengeance', 'should be Vengeance');
        assert(get_prefix(63) == 'Victory', 'should be Victory');
        assert(get_prefix(64) == 'Viper', 'should be Viper');
        assert(get_prefix(65) == 'Vortex', 'should be Vortex');
        assert(get_prefix(66) == 'Woe', 'should be Woe');
        assert(get_prefix(67) == 'Wrath', 'should be Wrath');
        assert(get_prefix(68) == 'Lights', 'should be Lights');
        assert(get_prefix(69) == 'Shimmering', 'should be Shimmering');
    }

    #[test]
    #[available_gas(6610)]
    fn test_get_suffix_gas() {
        get_suffix(1);
    }

    #[test]
    #[available_gas(117780)]
    fn test_get_suffix() {
        assert(get_suffix(1) == 'Bane', 'should be Bane');
        assert(get_suffix(2) == 'Root', 'should be Root');
        assert(get_suffix(3) == 'Bite', 'should be Bite');
        assert(get_suffix(4) == 'Song', 'should be Song');
        assert(get_suffix(5) == 'Roar', 'should be Roar');
        assert(get_suffix(6) == 'Grasp', 'should be Grasp');
        assert(get_suffix(7) == 'Instrument', 'should be Instrument');
        assert(get_suffix(8) == 'Glow', 'should be Glow');
        assert(get_suffix(9) == 'Bender', 'should be Bender');
        assert(get_suffix(10) == 'Shadow', 'should be Shadow');
        assert(get_suffix(11) == 'Whisper', 'should be Whisper');
        assert(get_suffix(12) == 'Shout', 'should be Shout');
        assert(get_suffix(13) == 'Growl', 'should be Growl');
        assert(get_suffix(14) == 'Tear', 'should be Tear');
        assert(get_suffix(15) == 'Peak', 'should be Peak');
        assert(get_suffix(16) == 'Form', 'should be Form');
        assert(get_suffix(17) == 'Sun', 'should be Sun');
        assert(get_suffix(18) == 'Moon', 'should be Moon');
    }

    #[test]
    #[available_gas(30000)]
    fn test_get_hash_gas() {
        get_hash(1, 1, 1);
    }

    #[test]
    #[available_gas(5015320)]
    fn test_get_hash() {
        let mut hashes = ArrayTrait::<felt252>::new();
        hashes.append(get_hash(1, 1, 1));
        hashes.append(get_hash(1, 1, 2));
        hashes.append(get_hash(1, 2, 1));
        hashes.append(get_hash(1, 2, 2));
        hashes.append(get_hash(2, 1, 1));
        hashes.append(get_hash(2, 1, 2));
        hashes.append(get_hash(2, 2, 1));
        hashes.append(get_hash(2, 2, 2));
        hashes.append(get_hash(3, 1, 1));
        hashes.append(get_hash(3, 1, 2));
        hashes.append(get_hash(3, 2, 1));
        hashes.append(get_hash(3, 2, 2));
        hashes.append(get_hash(4, 1, 1));
        hashes.append(get_hash(4, 1, 2));
        hashes.append(get_hash(4, 2, 1));
        hashes.append(get_hash(4, 2, 2));
        hashes.append(get_hash(5, 1, 1));
        hashes.append(get_hash(5, 1, 2));
        hashes.append(get_hash(5, 2, 1));
        hashes.append(get_hash(2, 1, 5));
        let mut i = 0;
        loop {
            if i == hashes.len() {
                break;
            }
            let hashes_clone = hashes.clone();
            let mut j = i + 1;
            loop {
                if j == hashes_clone.len() {
                    break;
                }
                assert(hashes_clone[i] != hashes_clone[j], 'hashes should be unique');
                j += 1;
            };
            i += 1;
        };
    }
    // @dev: the below test could technically verify there are no hash collisions
    //       across our entire hash space but it's impractical to run all 100k hashes
    //       so we're just running all combinations for the first beast
    #[test]
    #[available_gas(300000000000)]
    fn test_get_hash_extended() {
        let mut hashes = ArrayTrait::<felt252>::new();

        // iterarate over all possible hashes
        let mut beast = 1;
        loop {
            if beast == 1 {
                break;
            }
            let mut prefix = 1;
            loop {
                if prefix == 70 {
                    break;
                }
                let mut suffix = 1;
                loop {
                    if suffix == 19 {
                        break;
                    }
                    hashes.append(get_hash(beast, prefix, suffix));
                    suffix += 1;
                };
                prefix += 1;
            };
            beast += 1;
        };

        let mut i = 0;
        loop {
            if i == hashes.len() {
                break;
            }
            let hashes_clone = hashes.clone();
            let mut j = i + 1;
            loop {
                if j == hashes_clone.len() {
                    break;
                }
                assert(hashes_clone[i] != hashes_clone[j], 'hashes should be unique');
                j += 1;
            };
            i += 1;
        };
    }
}
