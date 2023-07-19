#!/bin/bash


#関数定義
function end_status () {
    if [ -z "$result" ]; then
       echo "実行結果がエラーとなりました"
       echo "入力内容に不備がある可能性がございます"
    fi
    echo ""
    echo "-------------------------------------------------"
    echo ""
}

# option 変数の初期化
option=""
count="0"

# オプション判定
for arg in "$@"; do

  count=$((count+1))

  #Aレコード
  if [ "$arg" = "A" ]; then
    option="1"
    option2="Aレコード"
    break
  elif [ "$arg" = "a" ]; then
    option="1"
    option2="Aレコード"
    break

  #NSレコード
  elif [ "$arg" = "NS" ]; then
    option="2"
    option2="NSレコード"
    break
  elif [ "$arg" = "ns" ]; then
    option="2"
    option2="NSレコード"
    break

  #MXレコード
  elif [ "$arg" = "MX" ]; then
    option="3"
    option2="MXレコード"
    break
  elif [ "$arg" = "mx" ]; then
    option="3"
    option2="MXレコード"
    break

  #TXTレコード
  elif [ "$arg" = "TXT" ]; then
    option="4"
    option2="TXTレコード"
    break
  elif [ "$arg" = "txt" ]; then
    option="4"
    option2="TXTレコード"
    break

  #ANYレコード
  elif [ "$arg" = "ANY" ]; then
    option="5"
    option2="全レコード"
    break
  elif [ "$arg" = "any" ]; then
    option="5"
    option2="全レコード"
    break

  #-Xレコード
  elif [ "$arg" = "-X" ]; then
    option="6"
    option2="逆引きレコード"
    break
  elif [ "$arg" = "-x" ]; then
    option="6"
    option2="逆引きレコード"
    break

  fi
done


#未指定処理
if [ -z "$option" ]; then
  option="1"
  count="0"
fi

# countの値によって$1を変換
if [ "$count" -eq 0 ]; then
  converted_arg="$1"
elif [ "$count" -eq 1 ]; then
  converted_arg="$2"
elif [ "$count" -eq 2 ]; then
  converted_arg="$1"
else
  converted_arg="$1"
fi


#処理開始表示
printf "
-------------------------------------------------
|           レコード検索を実行します             |
-------------------------------------------------
"
echo ""


#検索処理
cat $converted_arg | while read domain
do
  set +e
  echo "対象ドメイン $domain の $option2 検索を実行します"
  echo ""
  if [ "$option" = "1" ]; then
     result=$(dig +noall +answer A $domain |awk '{print $1,$5}')
     echo "$result"
     end_status
  elif [ "$option" = "2" ]; then
     result=$(dig +noall +answer NS $domain |awk '{print $1,$5}')
     echo "$result"
     end_status
  elif [ "$option" = "3" ]; then
     result=$(dig +noall +answer MX $domain |awk '{print $1,$5,$6}')
     echo "$result"
     end_status
  elif [ "$option" = "4" ]; then
     result=$(dig +noall +answer TXT $domain |awk '{$2=""; $3=""; $4=""; print}')
     echo "$result"
     end_status
  elif [ "$option" = "5" ]; then
     result=$(dig +noall +answer ANY $domain |awk '{$2=""; $3=""; print}')
     echo "$result"
     end_status
  elif [ "$option" = "6" ]; then
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

