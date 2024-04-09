CityDict ={
    'Seoul':  ['South Korea', 'Asia' ,9655000],
    'Tokyo':  ['Japan', 'Asia' ,14110000],
    'Beijing':  ['China', 'Asia', 21540000],
    'London':  ['United Kingdom', 'Europe' ,14800000],
    'Berlin':  ['Germany', 'Europe' ,3426000],
    'Mexico City':  ['Mexico', 'America' ,21200000],
}
#
# -----------------------------------------
# 1. 전체 데이터 출력
# 2. 수도 이름 오름차순 출력
# 3. 모든 도시의 인구수 내림차순 출력
# 4. 특정 도시의 정보 출력
# 5. 대륙별 인구수 계산 및 출력
# 이거 출력은 어떻게 진행되는 건가요?
# 6. 프로그램 종료
# -----------------------------------------

def menuPrint():
    print("----------------------------------------")
    print('1. 전체 데이터 출력')
    print('2. 수도 이름 오름차순 출력')
    print('3. 모든 도시의 인구수 내림차순 출력')
    print('4. 특정 도시의 정보 출력')
    print('5. 대륙별 인구수 계산 및 출력')
    print('6. 프로그램 종료')
    print("----------------------------------------")
    user = input("메뉴를 입력하세요: ")
    return int(user)

def show전체데이터출력(CityDictLocal):
    i = 1
    for key, value in CityDictLocal.items():
        print(f"[{i}] "+key + ": " + str(value))
        i += 1

def show수도이름오름차순출력(CityDictLocal):
    for idx, key in enumerate(sorted(CityDictLocal.keys())):
        print(f"[{idx+1}] {key:11s} : "
              f"{CityDictLocal[key][0]:15s} "
              f"{CityDictLocal[key][1]:10s} "
              f"{CityDictLocal[key][2]:>12,}")

def show모든도시의인구수내림차순출력(CityDictLocal):
    for idx, key in enumerate(sorted(CityDictLocal.keys(), key=lambda k: CityDictLocal[k][2], reverse=True)):
        print(f"[{idx+1}] {key:11s} : {CityDictLocal[key][2]:>12,}")

def show특정도시의정보출력(CityDictLocal):
    city = input("도시명을 입력하세요: ")
    if city in CityDictLocal:
        print(f"도시:{city}\n"
              f"국가:{CityDictLocal[city][0]}, "
              f"대륙:{CityDictLocal[city][1]}, "
              f"인구수:{CityDictLocal[city][2]:,}")
    else:
        print(f"도시이름: {city}은 key에 없습니다.")

def show대륙별인구수계산및출력(CityDictLocal):
    user = input("대륙 이름을 입력하세요(Asia, Europe, America): ")
    ContinentList = ["Asia", "Europe", "America"]
    total = 0
    if user in ContinentList:
        for name, detail in CityDictLocal.items():
            if detail[1] == user:
                print(f"{name}: {detail[2]:,}")
                total += detail[2]
        print(f"{user} 전체 인구수: {total:,}")
    else:
        print(f"{user}는 잘못된 대륙이름입니다.")

def main():
    while True:
        menu = menuPrint()
        if menu == 1:
            show전체데이터출력(CityDict)
        elif menu == 2:
            show수도이름오름차순출력(CityDict)
        elif menu == 3:
            show모든도시의인구수내림차순출력(CityDict)
        elif menu == 4:
            show특정도시의정보출력(CityDict)
        elif menu == 5:
            show대륙별인구수계산및출력(CityDict)
        elif menu == 6:
            print("프로그램을 종료합니다.")
            break
        else:
            print("1~6 사이의 숫자를 입력하세요")


if __name__ == '__main__':
    main()
