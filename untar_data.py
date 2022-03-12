import gzip
import shutil
from pathlib import Path
from typing import Final


DATA_PATH: Final = Path("data")
UNCLEAN_DATA_PATH: Path = DATA_PATH / "raw"
CLEAN_DATA_PATH = DATA_PATH / "preprocessed"


def main() -> None:
    for file in UNCLEAN_DATA_PATH.iterdir():
        if file.suffix == ".gz":
            output_filename: str = f"{CLEAN_DATA_PATH/file.stem}.csv"
            with gzip.open(file, "rb") as f_in, open(output_filename, "wb") as f_out:
                shutil.copyfileobj(f_in, f_out)


if __name__ == "__main__":
    main()
