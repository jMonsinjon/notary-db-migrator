#!/bin/sh

function display_help() {
    echo "This script will run a database migration for notary server or signer"
    echo ""
    echo "Parameters:"
    echo "    -h                      Display this help message."
    echo "    -c         *required*   Specify the notary component name (server, signer)."
    echo "    -d         *required*   Database URL to migrate (postgresql://$(username):$(password)@$(host):$(port)/$(database))."
    echo "Usage:"
    echo "    docker container run --rm -c server -d postgresql://user:password@host:1234/database"
}

function test_parameters() {
    if [[ -z "${component}" ]]; then
        echo "Please specify component name"
        display_help
        exit 1
    fi

    if [[ -z "${component}" ]]; then
        echo "Please specify component name"
        display_help
        exit 1
    fi

    if [[ "${component}" != "server" && "${component}" != "signer" ]]; then
        echo "The component name must be 'server' or 'signer'"
        display_help
        exit 1
    fi
}

main() {
    while getopts ":h:c:d:" opt; do
        case ${opt} in
            h )
                display_help
                exit 0
                ;;
            c )
                component=$OPTARG
                ;;
            d )
                database=$OPTARG
                ;;
            \? )
                display_help
                exit 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    test_parameters()

    echo "Starting DB migration"
    exec /migrate -verbose -path /migrations/$component/postgresql/ -database $database up
}

main "$@"
