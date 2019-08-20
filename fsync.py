from subprocess import Popen, PIPE
import argparse
import getpass

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Update the website on the aruba server through FTP')
    parser.add_argument('server', type=str, help="the ftp server")
    parser.add_argument('user', type=str, help="the username")

    args = parser.parse_args()

    print("Connecting to {}@{}".format(args.user, args.server))
    password = getpass.getpass()

    with Popen(["ftp", "-inv", args.server], stdout=PIPE, stdin=PIPE) as proc:
        script = """user {} {}
                    cd www.hswsnc.com
                    mput index.html
                    mput compiled.css
                    mput elm.js
                    mkdir res
                    mkdir res/images
                    mput res/images/*
                    bye\n""".format(args.user, password).encode("ASCII")
        (out, err) = proc.communicate(input=script)
        print(out.decode())
