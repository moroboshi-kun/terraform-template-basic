import json
import sys

def generate_backend_hcl(json_path, output_path):
    with open(json_path, 'r') as f:
        outputs = json.load(f)

    # Extract values from JSON output
    bucket = outputs.get('bucket_name', {}).get('value')
    key = outputs.get('state_key', {}).get('value', 'global/s3/terraform.tfstate')
    region = outputs.get('region', {}).get('value')
    dynamodb_table = outputs.get('dynamodb_table', {}).get('value')

    if not bucket or not region:
        print("Error: Missing required output values (bucket_name, region).")
        sys.exit(1)

    # Write HCL config
    with open(output_path, 'w') as f:
        f.write(f'bucket         = "{bucket}"\n')
        f.write(f'key            = "{key}"\n')
        f.write(f'region         = "{region}"\n')
        f.write(f'encrypt        = true\n')  # Always enable encryption
        if dynamodb_table:
            f.write(f'dynamodb_table = "{dynamodb_table}"\n')

    print(f"✅ Generated backend.hcl at: {output_path}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_backend_hcl.py <input_json> <output_hcl>")
        sys.exit(1)

    generate_backend_hcl(sys.argv[1], sys.argv[2])
