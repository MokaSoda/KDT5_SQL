import pickle



def fileCopyUsingBinaryMode():
    file1 = open("source.txt", 'rb')
    file2 = open('target.txt', 'wb')

    while True:
        buffered = file1.read(1024)
        print(len(buffered))
        if not buffered:
            break
        else:
            file2.write(buffered)

    file1.close()
    file2.close()

    print("파일 복사 예제 완료")


globallist = []


def pickleEx():
    # 해당 예제는 함수 내 실행시 오류 발생
    # 함수를 푼 후 실행
    class Person():
        def __init__(self, name, age):
            self.name = name
            self.age = age

        def __repr__(self):
            return f"Person(name={self.name}, age={self.age})"

    person = Person("John", 30)
    globallist.append(person)
    # 파일 열기
    file = open("person.pickle", "wb")

    # 객체 저장
    pickle.dump(globallist, file)

    # 파일 닫기
    file.close()

    print("Pickle 저장 완료")

    # 파일 열기
    file = open("person.pickle", "rb")
    result = pickle.load(file)

    print(result[0])


def tryexceptEx():
    x = 2
    y = 0

    try:
        print(x / y)
    except Exception as e:
        print(e)


def pandasLoadSQL():
    import pandas as pd
    import pymysql

    import sqlalchemy


    conn = pymysql.connect(
        host='175.122.58.102',
        port=33063,
        user='KMS',
        password='1234Q1@',
        db='ProjectDB',
        charset='utf8',
    )

    passwd = "1234q1!"
    # import sqlalchemy and connect db previously used
    engine = sqlalchemy.create_engine(f"mysql+pymysql://KMS:{passwd}@175.122.58.102:33063/ProjectDB")
    conn = engine.connect()

    # cur = conn.cursor()

    test = (pd.read_sql('select * from KMS_TestTable', engine))

    test = test.astype('object')

    test = test.apply(lambda x : x.str.replace(",", ""))
    test[test.columns[1:]]= test[test.columns[1:]].apply(pd.to_numeric, errors='coerce')

    test.to_sql('KMS_TestTable_Test', conn, if_exists='replace', index=False)



def exceptionValueEx():
    while 1:
        try:
            n = input("숫자 입력")
            n = int(n)
            break
        except ValueError:
            print("정수 아님, 다시입력요망")

    print("정수 입력 성공 ")


def tryexceptfinallyEX(values):
    total = None
    try :
        total = sum([values[x] for x in range(len(values))])
    except IndexError as err:
        print("인덱스 에러 : " + err)
    except Exception as err:
        print(err)
    else:
        print("에러없음 : " + str(values) )
    finally:
        print(f"sum = {total}")


def countChar():
    filename = 'proverbs.txt'
    file =  open(filename, 'r')

    freqs = {}
    for row in file:
        for char in row.strip():
            if char in freqs:
                freqs[char] += 1
            else:
                freqs[char] = 1

    print(freqs)
    file.close()




# tryexceptEx()
# exceptionValueEx()
pandasLoadSQL()
# tryexceptfinallyEX([1,2,3,5,6,7,8])
# countChar()