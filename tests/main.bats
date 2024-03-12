#!/usr/bin/env bats


@test "opendmarc: runs ok" {
  run docker run --rm --pull never --entrypoint sh $IMAGE -c \
    'opendmarc -V'
  [ "$status" -eq 0 ]
}

@test "opendmarc: has correct version" {
  run docker run --rm --pull never --entrypoint sh $IMAGE -c \
    "opendmarc -V | grep 'OpenDMARC Filter' \
                  | cut -d 'v' -f 2 \
                  | tr -d ' '"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  actual="$output"

  run sh -c "cat Makefile | grep $DOCKERFILE: \
                          | cut -d ':' -f 2 \
                          | cut -d ',' -f 1 \
                          | cut -d '-' -f 1 \
                          | cut -d '.' -f 1,2,3 \
                          | tr -d ' '"
  [ "$status" -eq 0 ]
  [ "$output" != '' ]
  expected="$output"

  [ "$actual" == "$expected" ]
}

@test "opendmarc: with SPF" {
  run docker run --rm --pull never --entrypoint sh $IMAGE -c \
    "opendmarc -V | grep -w 'WITH_SPF'"
  [ "$status" -eq 0 ]
}

@test "opendmarc: with SPF2" {
  run docker run --rm --pull never --entrypoint sh $IMAGE -c \
    "opendmarc -V | grep -w 'WITH_SPF2'"
  [ "$status" -eq 0 ]
}


@test "drop-in: opendmarc listens on 8890 port" {
  run docker rm -f test-opendmarc
  run docker run -d --name test-opendmarc --pull never -p 8890:8890 \
    -v $(pwd)/tests/resources/conf.d:/etc/opendmarc/conf.d:ro \
      $IMAGE
  [ "$status" -eq 0 ]
  run sleep 10

  run docker run --rm -i --link test-opendmarc:opendmarc \
    --entrypoint sh instrumentisto/nmap -c \
      'nmap -p 8890 opendmarc | grep "8890/tcp" | grep "open"'
  [ "$status" -eq 0 ]

  run docker rm -f test-opendmarc
}

@test "drop-in: opendmarc PID file is applied correctly" {
  run docker run --rm --pull never \
    -v $(pwd)/tests/resources/conf.d:/etc/opendmarc/conf.d:ro \
      $IMAGE sh -c \
        'opendmarc && sleep 10 && ls /run/opendmarc/another-one.pid'
  [ "$status" -eq 0 ]
}


@test "syslogd: runs ok" {
  run docker run --rm --pull never --entrypoint sh $IMAGE -c \
    '/sbin/syslogd --help'
  [ "$status" -eq 0 ]
}


@test "sendmail: is present" {
  run docker run --rm --pull never --entrypoint sh $IMAGE -c \
    'which sendmail'
  [ "$status" -eq 0 ]
}

@test "sendmail: runs ok" {
  run docker run --rm --pull never --entrypoint sh $IMAGE -c \
    'sendmail --help'
  [ "$status" -eq 0 ]
}
