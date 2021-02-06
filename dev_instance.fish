function dev
  set arg $argv[1]

  set account "moogcharlie@gmail.com"
  set instance "dev"
  set zone "us-central1-a"

  set cmd ""
  switch $arg
    case start
      set cmd "start"
    case stop
      set cmd "stop"
    case "" "status"
      gcloud compute instances list \
        --account $account
      return 0
    case "-h" "--help"
      set_color yellow; echo "dev (status, start, stop)"
      set_color normal
      return 0
    case '*'
      echo "command unknown: $arg"
      return -1
  end

  gcloud compute instances $cmd $instance \
    --account $account \
    --zone $zone \
    --async
end
