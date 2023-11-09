import csv

csv_file_path = 'airdrop.csv'

output = []

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    
    for row in csv_reader:
        address = row['owner']
        beast_id = int(row['beastId'])
        prefix = int(row['special2Id'])
        suffix = int(row['special3Id'])
        level = int(row['beastLevel'])
        health = int(row['beastHealth'])
        
        output_line = f'airdrops.append(Airdrop {{address: contract_address_const::<{address}>(),beast: PackableBeast {{ id: {beast_id}, prefix: {prefix}, suffix: {suffix}, level: {level}, health: {health} }}}});'
        
        output.append(output_line)
        
for line in output:
    print(line)
