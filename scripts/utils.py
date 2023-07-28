import json
import os
import base64

MAX_LEN_FELT = 31


def str_to_felt(text):
    if len(text) > MAX_LEN_FELT:
        raise Exception("Text length too long to convert to felt.")
    return int.from_bytes(text.encode(), "big")


def felt_to_str(felt):
    length = (felt.bit_length() + 7) // 8
    return felt.to_bytes(length, byteorder="big").decode("utf-8")


def str_to_felt_array(text):
    return [str_to_felt(t) for t in str_to_array(text)]


def str_to_array(text):
    return [text[i : i + MAX_LEN_FELT] for i in range(0, len(text), MAX_LEN_FELT)]


def uint256_to_int(uint256):
    return uint256[0] + uint256[1] * 2**128


def uint256(val):
    return (val & 2**128 - 1, (val & (2**256 - 2**128)) >> 128)


def hex_to_felt(val):
    return int(val, 16)


def prep_art():
    # header = '<svg id="leetart" width="100%" height="100%" viewBox="0 0 20000 20000" xmlns="http://www.w3.org/2000/svg"><style>#leetart{background-image:url('
    # footer = ");background-repeat:no-repeat;background-size:contain;background-position:center;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;}</style></svg>"
    assets_dir = "./assets"
    for fn in os.listdir(assets_dir):
        if not fn.startswith("t"):
            continue

        with open(f"{assets_dir}/{fn}", "rb") as f:
            content = base64.b64encode(f.read()).decode(encoding="utf-8")
            name = fn.split(".png")[0].split("_")[1].upper()
            to_cairo(name, content)


def to_cairo(name, content):
    print(f"else if beast == {name}")
    print("{")
    for c in str_to_array(content):
        print(f"    content.append('{c}');")

    print("}")


if __name__ == "__main__":
    prep_art()
    print(
        str_to_array(
            'data:image/svg+xml;utf8,<svg%20width="100%"%20height="100%"%20viewBox="0%200%2020000%2020000"%20xmlns="http://www.w3.org/2000/svg"><style>svg{background-image:url(data:image/png;base64,'
        )
    )
