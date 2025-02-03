#!/usr/bin/env python3
import subprocess
import re


def get_context_list():
    try:
        # Run the meroctl command and capture output
        result = subprocess.run(
            ["meroctl", "--node-name", "node1", "context", "ls"],
            capture_output=True,
            text=True,
            check=True,
        )

        if result.returncode != 0:
            raise subprocess.CalledProcessError(
                result.returncode, "meroctl", result.stderr
            )

        # Initialize list to store context data
        context_list = []

        # Pattern to match the three fields
        pattern = r"id: ([^\n]+)\napplication_id: ([^\n]+)\nroot_hash: ([^\n]+)"

        # Find all matches in the output
        matches = re.finditer(pattern, result.stdout)

        # Create list of dictionaries
        for match in matches:
            context = {
                "id": match.group(1),
                "application_id": match.group(2),
                "root_hash": match.group(3),
            }
            context_list.append(context)

        return context_list

    except subprocess.CalledProcessError as e:
        print(f"Command failed with error: {e.stderr}")
        return None
    except re.error as e:
        print(f"Regex pattern matching failed: {str(e)}")
        return None


if __name__ == "__main__":
    result_contexts = get_context_list()
    if result_contexts:
        # Print the parsed data
        for context in result_contexts:
            print("\nContext:")
            for key, value in context.items():
                print(f"{key}: {value}")
