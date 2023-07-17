#!/bin/bash

set -e


function end_status () {
    if [ -z "$result" ]; then
       echo "実行結果がエラーとなりました"
       echo "入力内容に不備がある可能性がございます"
    fi
    echo ""
    echo "-------------------------------------------------"
    echo ""
}


printf "
-------------------------------------------------
|      検索対象レコードタイプを入力下さい        |
-------------------------------------------------
"
echo ""


select type in 'Aレコード' 'NSレコード' 'MXレコード' 'TXTレコード' '全てのレコード' '逆引き'
do
  echo ""
  echo "$type検索が選択されました"
  if [ "$type" = "Aレコード" ]; then
      type="1"
      type2="Aレコード"
      break
  elif [ "$type" = "NSレコード" ]; then
      type="2"
      type2="NSレコード"
      break
  elif [ "$type" = "MXレコード" ]; then
      type="3"
      type2="MXレコード"
      break
  elif [ "$type" = "TXTレコード" ]; then
      type="4"
      type2="TXTレコード"
      break
  elif [ "$type" = "全てのレコード" ]; then
      type="5"
      type2="全てのレコード"
      break
  elif [ "$type" = "逆引き" ]; then
      type="6"
      type2="逆引き"
      break
  else
      echo "error"
  fi
done


printf "
-------------------------------------------------
|           レコード検索を実行します             |
-------------------------------------------------
"
echo ""

cat $1 | while read domain
do
  set +e
  echo "対象ドメイン $domain の $type2 検索を実行します"
  echo ""
  if [ "$type" = "1" ]; then
     result=$(dig +noall +answer A $domain |awk '{print $1,$5}')
     echo "$result"
     end_status
  elif [ "$type" = "2" ]; then
     result=$(dig +noall +answer NS $domain |awk '{print $1,$5}')
     echo "$result"
     end_status
  elif [ "$type" = "3" ]; then
     result=$(dig +noall +answer MX $domain |awk '{print $1,$5,$6}')
     echo "$result"
     end_status
  elif [ "$type" = "4" ]; then
     result=$(dig +noall +answer TXT $domain |awk '{$2=""; $3=""; $4=""; print}')
     echo "$result"
     end_status
  elif [ "$type" = "5" ]; then
     result=$(dig +noall +answer ANY $domain |awk '{$2=""; $3=""; print}')
     echo "$result"
     end_status
  elif [ "$type" = "6" ]; then
     result=$(dig +noall +answer -x $domain |awk '{print $5}')
     echo "逆引き結果 : $result"
     echo ""
     end_status
  else
      echo "error"
      end_status
  fi
  echo ""
done

