#!/usr/bin/env bash

#Terminates script execution after first failed (returned non-zero exit code)
# command and treat unset variables as errors.
set -ue +xv
terraform init -backend-config=$statefile -backend-config=$storage_access_key -backend-config=$storage_account_name

#TF:
function tf_plan {
    terraform plan -out=$outfile
}

case "${1-}" in
    apply)
        tf_plan && terraform apply $outfile
        ;;

    apply-saved)
        if [ ! -f $outfile ]; then tf_plan; fi
        terraform apply $outfile
        ;;

    show)
        terraform show
        ;;

    *)
        tf_plan

        echo ""
        echo "Not applying changes. Call one of the following to apply changes:"
        echo " - '$0 apply': prepares and applies new plan"
        echo " - '$0 apply-saved': applies saved plan ($outfile)"
        echo ""
        echo "Other commands:"
        echo " - '$0 show': shows the current state"
        ;;
esac