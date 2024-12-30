import openpyxl
import json


def read_excel_dynamically(file_path):
    """
    Dynamically reads the Excel file to fetch key-value pairs.
    :param file_path: Path to the Excel file.
    :return: Dictionary of key-value pairs.
    """
    wb = openpyxl.load_workbook(file_path)
    sheet = wb.active

    # Extract headers (keys) from the first row
    headers = [cell.value for cell in sheet[1]]
    key_col = value_col = None

    # Dynamically determine key and value column
    for index, header in enumerate(headers):
        if header and "key" in header.lower():
            key_col = index
        elif header and "value" in header.lower():
            value_col = index

    if key_col is None or value_col is None:
        raise ValueError("The Excel sheet must contain 'key' and 'value' columns.")

    # Extract key-value pairs from the sheet
    variables = {}
    for row in sheet.iter_rows(min_row=2, values_only=True):  # Skip the header row
        key = row[key_col]
        value = row[value_col]
        if key:  # Only include non-empty keys
            variables[key] = value

    return variables


def update_ansible_json(file_path, variables):
    """
    Update the Ansible JSON configuration file by searching and updating keys with values.
    :param file_path: Path to the Ansible JSON configuration file.
    :param variables: Dictionary of key-value pairs to update the JSON configuration.
    """
    # Read the existing configuration if it exists
    try:
        with open(file_path, 'r') as file:
            config = json.load(file)
    except FileNotFoundError:
        raise ValueError(f"The file '{file_path}' does not exist!")

    # Iterate through the keys in the Excel data and update the corresponding key in the JSON file
    for key, value in variables.items():
        if key in config:
            config[key] = value  # Update the value for the key
        else:
            print(f"Key '{key}' not found in the JSON configuration.")

    # Write the updated configuration back to the file
    with open(file_path, 'w') as file:
        json.dump(config, file, indent=4)


def main():
    excel_file = "variables.xlsx"  # Path to the Excel file
    ansible_json_file = "ansible_config.json"  # Path to the Ansible JSON configuration file

    print("Reading variables from Excel dynamically...")
    variables = read_excel_dynamically(excel_file)
    print("Fetched variables:", variables)

    print("Updating Ansible JSON configuration file...")
    update_ansible_json(ansible_json_file, variables)
    print("Ansible JSON configuration file updated successfully!")


if __name__ == "__main__":
    main()
