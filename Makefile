### Ushbu fayl doimiy amallar(build, fix, build_runner...) uchun qisqa terminal komandalari
### Bitta kommand ichida ko'pgina ketma-ket bajariladigan operatsiyalar yozish mumkin.
### Masalan quyidagi kod, clean qilib pub get qiladi. Terminalga ``make my_command`` yozish kerak.
### my_command:
### 	flutter clean
### 	flutter pub get

# Assetslar uchun generatsiya qilish
res:
	dart run res_generator:generate


# Words uchun tarjima qilish
translate:
	dart run res_generator:translate


# Generatsiya pakagelari uchun, bir martalik generatsiya
gen-once:
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs


# Generatsiya pakagelari uchun, o'zgarishlarni eshitib turadi
gen:
	dart run build_runner watch --delete-conflicting-outputs


# Clean qilish uchun
clean:
	flutter clean
	flutter pub get


# Apk build qilish uchun:
# apk build qiladi, nomini bir_qadam_sana.apk ko'rinisiga o'tkazadi
# papkani ochadi, gitdagi joriy branchdagi ohirgi 5 commitni, changes.txtga saqlaydi
build-apk:
	flutter clean
	flutter build apk --release
	mv ./build/app/outputs/flutter-apk/app-release.apk "./build/app/outputs/flutter-apk/$$(grep '^name:' pubspec.yaml | awk '{print $$2}' | tr -d '[:space:]')_$$(date +%d.%m.%Y).apk"
	open ./build/app/outputs/flutter-apk/


# iosda uchrab turadigan odatiy xatoliklarni oldini oladi
fix-ios:
	cd ios; pod cache clean --all; pod clean; pod deintegrate; sudo gem install cocoapods-deintegrate cocoapods-clean; sudo arch -x86_64 gem install ffi; arch -x86_64 pod repo update; arch -x86_64 pod install


# Dastur kodidagi constga oid kichik xatolar uchun
fix:
	dart fix --apply
	dart format .

# Dasturni release versiyada 00008110-001C35D90AEB801E shu idlik deviceda ishga tushurish
# O'ziningizga moslab olishingiz mumkin. Hozir buyerda o'zimni telefonim.
run:
	flutter run -d  00008110-001C35D90AEB801E --release


# Prompt generate qilish uchun
prompt:
	dart run prompt_generator:generate

# flutter run -d web-server --web-port=8080 --target=lib/common/docs/doc.dart