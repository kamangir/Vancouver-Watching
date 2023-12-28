#! /usr/bin/env bash

function vancouver_watching_ingest() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local options="area=<area>,count=<-1>,dryrun,gif,model=<model-id>,~process,publish,~upload"
        local args="[<args>]"
        abcli_show_usage "vanwatch ingest$ABCUL[$options]$ABCUL[-|<object-name>]$ABCUL$args" \
            "ingest <area> -> <object-name>."

        if [ "$(abcli_keyword_is $2 verbose)" == true ]; then
            python3 -m vancouver_watching.ingest --help
        fi
        return
    fi

    local area=$(abcli_option "$options" area vancouver)
    local count=$(abcli_option_int "$options" count -1)
    local do_dryrun=$(abcli_option_int "$options" dryrun 0)
    local do_process=$(abcli_option_int "$options" process 1)
    local do_upload=$(abcli_option_int "$options" upload $(abcli_not $do_dryrun))

    local object_name=$(abcli_clarify_object $2 $(abcli_string_timestamp))
    local object_path=$abcli_object_root/$object_name

    local discovery_object=$(
        abcli_tag search \
            $area,vancouver_watching,discovery \
            --count 1 \
            --log 0
    )
    if [ -z "$discovery_object" ]; then
        abcli_log_error "-vancouver_watching: ingest: $area: area not found."
        return 1
    fi

    abcli_download - $discovery_object

    cp -v \
        $abcli_object_root/$discovery_object/$area.geojson \
        $object_path/

    python3 -m vancouver_watching.ingest \
        --count $count \
        --do_dryrun $do_dryrun \
        --geojson $object_path/$area.geojson \
        "${@:3}"

    abcli_tag set \
        $object_name \
        $area,vancouver_watching,ingest
    abcli_cache write $object_name.area $area

    [[ "$do_upload" == 1 ]] &&
        abcli_upload object $object_name

    [[ "$do_process" == 1 ]] &&
        vancouver_watching_process \
            "$options" \
            "$object_name" \
            "${@:3}"
}
