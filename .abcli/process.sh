#! /usr/bin/env bash

# https://hub.ultralytics.com/models/R6nMlK6kQjSsQ76MPqQM?tab=preview
export vancouver_watching_default_model="R6nMlK6kQjSsQ76MPqQM"

function vancouver_watching_process() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local options="~download,model=<model-id>,publish,~upload"
        abcli_show_usage "vanwatch process$ABCUL[$options]$ABCUL[.|<object-name>]$ABCUL[<args>]" \
            "process <object-name>."
        return
    fi

    local do_dryrun=$(abcli_option_int "$options" dryrun 0)
    local do_download=$(abcli_option_int "$options" download $(abcli_not $do_dryrun))
    local do_upload=$(abcli_option_int "$options" upload $(abcli_not $do_dryrun))
    local do_publish=$(abcli_option_int "$options" publish 0)
    local model_id=$(abcli_option "$options" model $vancouver_watching_default_model)

    local object_name=$(abcli_clarify_object $2 .)
    [[ "$do_download" == 1 ]] &&
        abcli_download object $object_name

    local area=$(abcli_cache read $object_name.area)
    if [[ -z "$area" ]]; then
        abcli_log_error "-vancouver_watching: process: $object_name: area not found."
        return 1
    fi

    python3 -m vancouver_watching.ai \
        process \
        --do_dryrun $do_dryrun \
        --model_id $model_id \
        --geojson $abcli_object_root/$object_name/$area.geojson \
        "${@:3}"

    [[ "$do_upload" == 1 ]] &&
        abcli_upload object $object_name

    [[ "$do_publish" == 1 ]] &&
        abcli_tag set $object_name published
}
