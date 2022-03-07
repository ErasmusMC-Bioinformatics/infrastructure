#!/usr/bin/env python

# Given a TSV
# And a set of columns to unique on
# and an option for how to process non-unique columns (first, last, avg)
import csv
import argparse

parser = argparse.ArgumentParser(prog='Unique on columns')
parser.add_argument('input', type=argparse.FileType('r'), help='Input File')
parser.add_argument('output', type=argparse.FileType('w'), help='Output File')
parser.add_argument('--has_header', action='store_true', help='File has a header')
parser.add_argument('--column', type=int, nargs='+', help='Columns to use as a unique key (1-indexed)')
parser.add_argument('--delimiter', type=str, help='Columns to use as a unique key', default='\t')
args = parser.parse_args()

seen = []

tablereader = csv.reader(args.input, delimiter=args.delimiter, quotechar='"')
tablewriter = csv.writer(args.output, delimiter=args.delimiter, quotechar='"')

if args.has_header:
    row = next(tablereader)
    tablewriter.writerow(row)

for row in tablereader:
    key = tuple([row[col - 1] for col in args.column])

    if key not in seen:
        tablewriter.writerow(row)
        seen.append(key)
    else:
        continue
