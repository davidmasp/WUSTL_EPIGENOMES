
import requests
import concurrent.futures
import os
from os.path import exists
from tqdm import tqdm
import json
import click

# from https://stackoverflow.com/a/62113293
def download(prms: tuple):
    url, fname = prms
    resp = requests.get(url, stream=True)
    total = int(resp.headers.get('content-length', 0))
    with open(fname, 'wb') as file, tqdm(
        desc=fname,
        total=total,
        unit='iB',
        unit_scale=True,
        unit_divisor=1024,
    ) as bar:
        for data in resp.iter_content(chunk_size=1024):
            size = file.write(data)
            bar.update(size)

# script ------------------------------------------------------------------

@click.command()
@click.option('-p','--threads', default=3, help='Number of parallel processes.')
@click.option('-i','--input', default="codes.json", help='Codes file (in json).')
def hello(threads, input):
    """Simple program that greets NAME for a total of COUNT times."""
    f = open('codes.json')
    data = json.load(f)
    params = []
    for code in data:
        lpath = code['local_path']
        base_url = code['base_url']
        base_file = code['base_file']
        os.makedirs(lpath, exist_ok=True)
        for cd in code['codes']:
            file_out = base_file.format(cd)
            url = os.path.join(base_url, file_out)
            fname = os.path.join(lpath, file_out)
            fex = exists(fname)
            if fex:
                click.echo(f"{fname} already exists.")
            else:
                obj = (url, fname)
                params.append(obj)
    if len(params) == 0:
        click.echo(f"No files to download")
    else:
        # here starts the parll part
        with concurrent.futures.ThreadPoolExecutor(max_workers=threads) as executor:
            executor.map(download, params)

if __name__ == '__main__':
    hello()

