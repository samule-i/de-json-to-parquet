import json


def read_json_file(filepath: str):
    with open(filepath) as fp:
        return json.loads(fp.read())
