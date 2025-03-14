import Config

config :super_worker,
  # Add supervisor by config file.
  sup_cfg_1: [  # Declare config by config file.
    options: [
      number_of_partitions: 2,
      link: true,
      report_to: {SuperWorkerExample.MyModule, :report, []}
    ],
    groups: [
      group1: [
        options: [
          restart_strategy: :one_for_all
        ],
        workers: [
          worker1: [
            task: {SuperWorkerExample.MyModule, :task, [15]}
          ],
          worker2: [
            options: [

            ],
            task: {SuperWorkerExample.MyModule, :task_crash, [15, 5]}
          ]
        ]
      ],
    ],
    chains: [
      chain1: [
        options: [
          restart_strategy: :one_for_one,
          finished_callback: {SuperWorkerExample.MyModule, :print, [:chain1]},
          send_type: :round_robin
        ],
        default_worker_options: [
          # restart_strategy: :transient,
          num_workers: 1
        ],
        workers: [
          worker1: [
            task: {SuperWorkerExample.MyModule, :task, [15]}
          ],
          worker2: [
            options: [
              num_workers: 5,
              # restart_strategy: :transient
            ],
            task: {SuperWorkerExample.MyModule, :task_crash, [15, 5]}
          ]
        ]
      ]
    ]
  ]
