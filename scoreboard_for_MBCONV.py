import sys

def read_output_file(filename):
    """Reads output file and returns structured data as a dictionary."""
    results = {}
    current_layer = None
    current_channel = None
    current_data = []

    try:
        with open(filename, "r") as f:
            for line in f:
                line = line.strip()
                
                # Detect layer name
                if line.endswith(":") and not line.startswith("Channel"):
                    if current_layer is not None:
                        results[current_layer] = current_data  # Save previous layer data
                    current_layer = line[:-1]  # Remove colon
                    current_data = []  # Reset for new layer
                
                # Detect channel number
                elif line.startswith("Channel"):
                    current_channel = int(line.split()[1][:-1])  # Extract channel number
                    current_data.append([])  # Initialize a new channel list
                
                # Read numerical data
                elif line and current_channel is not None:
                    if len(current_data) == 0:
                        print(f"Error: Missing channel declaration before data in {filename}")
                        sys.exit(1)
                    
                    # Convert float values to integers before appending
                    current_data[-1].extend(map(lambda x: int(float(x)), line.split()))  

        # Save last layer read
        if current_layer is not None:
            results[current_layer] = current_data

    except FileNotFoundError:
        print(f"Error: File {filename} not found!")
        sys.exit(1)

    return results

def compare_files(file1, file2):
    """Compares two output files line-by-line and reports differences."""
    data1 = read_output_file(file1)
    data2 = read_output_file(file2)

    if set(data1.keys()) != set(data2.keys()):
        print("Mismatch in layer names!")
        print("File 1 layers:", list(data1.keys()))
        print("File 2 layers:", list(data2.keys()))
        return

    total_mismatches = 0
    for layer in data1:
        print(f"Comparing layer: {layer}")

        # Check if both layers have the same number of channels
        if len(data1[layer]) != len(data2[layer]):
            print(f"  Channel count mismatch in {layer}:")
            print(f"    File 1: {len(data1[layer])} channels")
            print(f"    File 2: {len(data2[layer])} channels")
            total_mismatches += 1
            continue

        # Compare pixel values in each channel
        for ch in range(len(data1[layer])):
            if len(data1[layer][ch]) != len(data2[layer][ch]):
                print(f"  Mismatch in channel {ch} of {layer}: different size!")
                total_mismatches += 1
                continue

            for i in range(len(data1[layer][ch])):
                if data1[layer][ch][i] != data2[layer][ch][i]:
                    print(f"  Difference in {layer} - Channel {ch}, Position {i}: {data1[layer][ch][i]} != {data2[layer][ch][i]}")
                    total_mismatches += 1

    if total_mismatches == 0:
        print("✅ The two files match exactly!")
    else:
        print(f"❌ {total_mismatches} differences found!")

# Run comparison
file1 = "golden_MB_CONV_output.txt"
file2 = "output.txt"
compare_files(file1, file2)
