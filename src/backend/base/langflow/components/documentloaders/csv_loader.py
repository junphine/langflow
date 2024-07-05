from pathlib import Path
from langflow.io import BoolInput, FileInput, Output
from langflow.custom import Component
from langflow.io import MessageTextInput, Output
from langflow.schema import Data
import csv
from io import StringIO


class CSVLoaderComponent(Component):
    name = "CSVLoader"
    display_name = "CSV Loader"
    description = "Load a CSV file to a list of Data objects"
    icon = "file-csv"

    inputs = [
        FileInput(
            name="path",
            display_name="Path",
            file_types=['csv','tsv'],
            info=f"Supported file types: {', '.join(['csv','tsv'])}",
        ),
        BoolInput(
            name="silent_errors",
            display_name="Silent Errors",
            advanced=True,
            info="If true, errors will not raise an exception.",
        ),
    ]
    outputs = [
        Output(name="data_list", display_name="Data List", method="convert_csv_to_data"),
    ]

    def convert_csv_to_data(self) -> list[Data]:
        silent_errors = self.silent_errors
        if not self.path:
            raise ValueError("Please, upload a file to use this component.")
        try:
            resolved_path = self.resolve_path(self.path)
            extension = Path(resolved_path).suffix[1:].lower()

            if extension=='tsv':
                csv_args={
                    'delimiter': '\t',
                    'quotechar': '"'
                }
            else:
                csv_args={
                    'delimiter': ',',
                    'quotechar': '"'
                }

            # Create a CSV reader object
            csv_reader = csv.DictReader(resolved_path,**csv_args)

            # Convert each row to a Data object
            result = []
            for row in csv_reader:
                result.append(Data(data=row))

            self.status = result
            return result

        except csv.Error as e:
            error_message = f"CSV parsing error: {str(e)}"
            self.status = error_message
            if not silent_errors:
                raise ValueError(error_message)
            return [Data(data={"error": error_message})]

        except Exception as e:
            error_message = f"An error occurred: {str(e)}"
            self.status = error_message
            return [Data(data={"error": error_message})]

