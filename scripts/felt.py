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


def build_svg_with_felt_array(base64):
    header = '<svg id="leetart" width="100%" height="100%" viewBox="0 0 20000 20000" xmlns="http://www.w3.org/2000/svg"><style>#leetart{background-image:url('
    footer = ");background-repeat:no-repeat;background-size:contain;background-position:center;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;}</style></svg>"
    for b in str_to_array(header):
        print(f"content.append('{b}');")

    for b in str_to_array(base64):
        print(f"content.append('{b}');")

    for b in str_to_array(footer):
        print(f"content.append('{b}');")


def build_encoded_svg():
    header = '<svg id="leetart" width="100%" height="100%" viewBox="0 0 20000 20000" xmlns="http://www.w3.org/2000/svg"><style>#leetart{background-image:url('
    footer = ");background-repeat:no-repeat;background-size:contain;background-position:center;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;}</style></svg>"
    assets_dir = "./assets"
    for fn in os.listdir(assets_dir):
        with open(f"{assets_dir}/{fn}", "rb") as f:
            content = f"data:image/png;base64,{base64.b64encode(f.read()).decode(encoding='utf-8')}"
            svg = header + content + footer
            encoded = base64.b64encode(svg.encode("ascii")).decode(encoding="utf-8")
            final = f"data:image/svg+xml;base64,{encoded}"
            final_array = str_to_array(final)
            print(fn, len(final), len(final_array))
            for b in final_array:
                print(b)
            break


if __name__ == "__main__":
    # base64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAXdJREFUWIXFVkkOwyAMNFEfnSfwa3opiTPM2BClrSVEwuJlvFHMrNkf6ZUdaPX8Lvt3lGhqtMrnJ8eWalevM66r/xUKEUCr/f8TyFwQaPUcZqfPvxkHhwKtnszLziH1a9n+LBX7pKG3uiuDSGRC7qCzoXCvBGNadi6IrXl3qmA2uxFMPjjV3ShY/X0aA4pU6rF1H8AeWT8vIaCswFRlvPAsyOH5HinBGGdQK7dsCIlKL8wMRiqDovQdChG7gP5EJmwfi5jiaRb42Ez7T0V95gYcEgEFN7OQ3cug7/+HAhnMTMlMeSxazB20HWc1nTHKEFCUvge8AD/jXuSGjgTjcTQjtE4pkVmXKYMGTSPABOB6JBwFd1pWQPUM1c77rBS6NKMMfmbB0FgWERgeJEr4UL2SqujPRHR5kGTCVdp5YmcyGVPdcKYEi3Ybtvvy2Zh6z7E06usqzdhdv38ooC5GTFYE+b2hn6iOx4bqerP7ZNy++MgYSvGv6Q3l4pZkdWJdwgAAAABJRU5ErkJggg=="
    # build_svg_with_felt_array(base64)

    build_encoded_svg()
