from src.json_file_reader.reader import read_json_file as jsfr


def test_jsfr_returns_json_string():
    result = jsfr("test/data/test_data.json")
    data = [
        {
            "item_name": "1990s Gameboy",
            "description": "But mom I want one!",
            "price": 1599,
            "category_name": "Electronics"
        },
        {
            "item_name": "Antique Bookshelf",
            "description": "Makes your apartment smell like rich mahogany",
            "price": 7999,
            "category_name": "Household"
        }
    ]
    assert result == data
