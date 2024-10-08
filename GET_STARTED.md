# Сборка и запуск приложения

## Требования
- [macOS Sonoma 14.0](https://apps.apple.com/ru/app/macos-sonoma/id6450717509?mt=12) или [macOS Sequoia 15.0](https://apps.apple.com/ru/app/macos-sequoia/id6596773750?mt=12) (рекоммендуется)
- [Xcode 16.0](https://apps.apple.com/ru/app/xcode/id497799835?mt=12)
- [SwiftLint](https://github.com/realm/SwiftLint)

## Настройка окружения
 ### 1. Установите Xcode
 - Через [AppStore](https://apps.apple.com/ru/app/xcode/id497799835?mt=12)
   <img title="AppStore" alt="AppStore screenshot" src="https://s379vlx.storage.yandex.net/rdisk/50bbcdb99d276e8bbb6a7f4cc6cca49f9be216c852846d1e175e7bc173b18035/6703dcfe/fKqInKw3d7bLFOeFnMGnhAxGMcy3dv49X-Rya5HzCm8mCne-Ug3YQgUIku_5ypnb_hr3MszM3gevy2nsUFtXjczevxBA30cYgEMhBl2E_UOr8npumZHI4midPdWhecNq?uid=1130000067515093&filename=xcode_appstore.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=539042&hid=a16770c11f7cac5e653be5e1e12c80a0&media_type=image&tknv=v2&etag=3a054d18a353477b9932c908a11fac68&ts=623e2b2d2bb80&s=74de18d70f76678c0e3aceec2afb8869ca761b796c33e172e55cf5b9206f0e25&pb=U2FsdGVkX19B573Taz-N0CnKpVRclFndRdH2ON0qcHURzlY9fDJTdQ_L4qT3a9A-iKJBDraBZpGbZaARiFw8fG4YyQrfk1_Tboo6LlYurCtrR34ttoLs8tjamwvTtDmA">
  
 - С помощью [Xcodes](https://www.xcodes.app) (Более быстрый вариант)
   <img title="Xcodes" alt="Xcodes screenshot" src="https://s143klg.storage.yandex.net/rdisk/19712a9d00607e4008003296e2c2dde099181dc2335bdfc7d45081f9baf3f5e3/6703dd91/fKqInKw3d7bLFOeFnMGnhL-U11gCh9vLooeyQwgJfAW2U6U51yKp8Wo4I-6AAtJ4EkrU-jloK_O618dUkHK_At_iSmoaekuDfEG5qEKzi56r8npumZHI4midPdWhecNq?uid=1130000067515093&filename=xcode_xcodes.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=568408&hid=4c988ba52cc1025f3e10cfc3359c5bf0&media_type=image&tknv=v2&etag=c25f103328d0327d780078cb2eda4166&ts=623e2bb95c640&s=f97c5000d57d55b6116c1bd9d27a057ac3a4f4664397a64c062f6177c1b44f2a&pb=U2FsdGVkX18AMDg0k0_te4hMsbttewODDG_NYicTNra8Heq_Ev87nrdjIIaDSHz6OhgvmEnij4MNtIdgCPH0W_io80KqTI77kUFzD8b_RcWhZGqHm3v1YzBzLM4CCbWK">

### 2. Установите SwiftLint
  - Через [HomeBrew](https://brew.sh)
    
    ```bash
        brew install swiftlint
    ```
  - Через [Mint](https://github.com/yonaskolb/mint)
    
    ```bash
        mint install realm/SwiftLint
    ```

 ### 3. Клонируйте репозиторий
  ```bash
    git clone https://github.com/prokyhouse/moodTracker.git
  ```

## Запуск проекта
<img title="Xcode welcome screen" alt="Xcode welcome screen" src="https://s809sas.storage.yandex.net/rdisk/042a31f32b366949c55acb520e5c08b643c04d30cfa7d211e706806de03c4a87/6703e032/fKqInKw3d7bLFOeFnMGnhBDYiLwLs4WVYYbWn9tOUiAw_X8BeX-1_NYpt_v4Haogdtpp4EW8WB14A591nGt2uTTMeEWQud7inNQAIdONx9mr8npumZHI4midPdWhecNq?uid=1130000067515093&filename=welcomeScreen.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=267958&hid=8add913967fd669288ddb0dfa6998042&media_type=image&tknv=v2&etag=47b6900daee5ed265d0645541d8a965f&ts=623e2e3b2f080&s=afbbbd894ab1c54c80f52e3b7eb9c41aedf077828f928b29a268ace50291cca3&pb=U2FsdGVkX1_PPkxfi3sTxrrMqv1O883UCThgQZSJ3pQY-lOw_0jCDG5SJbnHTLg4y6c2FgFwOyVfZEXij6K170JL_o8r-blc3QVYxopl5wB88-FRhIJy4koCCA29PFf9">

Заходим в директорию ```../moodTracker/MoodTracker``` и выбираем ```MoodTracker.xcodeproj``` файл.
<img title="Open Finder" alt="Open Finder" src="https://s490vla.storage.yandex.net/rdisk/c540ee599d228245e75a02590b98a8a12342d76be45affec6002371460ed3de5/6703e12e/fKqInKw3d7bLFOeFnMGnhJQm6hRKe-DOLWuG99QLPz1ZuYT3MIZ_G5N4SAua0bjYe-hPeN25WEfWnHfK4IQvKfUymIDe2DGc6VzWjwhdeFGr8npumZHI4midPdWhecNq?uid=1130000067515093&filename=finder.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=338857&hid=4512fd2228731694a8e6f998c5bfcb4e&media_type=image&tknv=v2&etag=d184241104c7b87c539bf8eb153f833a&ts=623e2f2b82780&s=ce72fde458fc8c2cd2be267f54f027863c37715ade1df2e16c1f9301cc5fbacf&pb=U2FsdGVkX1_oOcU2_3Lyd0GNsnpOMDA4dMNp56-a1OOPbNkDmSv2SYLhalbyhRl8GAhPfc-PybXdGrMRj0verTM_Defp808TblCiMRH_6JzZkkcOrpwJsLCH5HO3sjCk">

 ### 4.1. На симуляторе
 Перед запуском, нужно убедиться, что в верхней панели выбран симулятор. Если нет, то выбираем любой доступный.
 
 <img title="Choose simulator" alt="Choose simulator" src="https://s455vlx.storage.yandex.net/rdisk/5160614d04a6c775c2d58ba92e0eedb6c58d860766bd8516b957dab2391262df/6703e574/fKqInKw3d7bLFOeFnMGnhHgYT_MFZyXXSX2ydLEPrX3AohezMOe8qB013CLwvOvVnE8l25W8k77U5M4qttOT7DuSEcCJLwSVKcsTYeAgWwSr8npumZHI4midPdWhecNq?uid=1130000067515093&filename=choose_device.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=485042&hid=74ef2b660a4cf3b9d144d17cd498bad3&media_type=image&tknv=v2&etag=399cc1e86a84bde1e91b0253caf5fb83&ts=623e333ed4500&s=f1a8c666bf0984e08ef170238cef67e8c4cfb6fdaff48e18d7375bf4605a1b36&pb=U2FsdGVkX18BIX_Hb-icyY6dKLCAG1eVv9tYSExTgOYLNrwSWDVPGLny4u6PGD5hTJBFjQaR18CVUtXV1HgXNts9PRGmzii6Il8Dpn6OCjKyCXISYqXIbFxiPin43MaA">

 > [!TIP]
 > Если в списке нет доступных симуляторов, дополнительно нужно загрузить, предложенную IDE, версию iOS.

 <img title="Download simulator" alt="Download simulator" src="https://s326sas.storage.yandex.net/rdisk/a3c6611b5fdfd09526f9794ceb3ba69512797aca9d4aafbff0ecafb92657cdca/67053819/fKqInKw3d7bLFOeFnMGnhMQa7Y_WoYtXYNd94HoCIn8goREIuTKe4GXRmPPUNQ3zLXTnO9xuwckokLwhRPH0A3_p47dw1rPJh4MbO5PZrv-r8npumZHI4midPdWhecNq?uid=1130000067515093&filename=download.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=91729&hid=1cbd3e4e5b91bfcd0fabeeaf394293d8&media_type=image&tknv=v2&etag=9bb99acc84fd65bd591c040042e07f18&ts=623f7633b7840&s=6ed0c092b1e6d1e852df11ab5c02993b0fc2fa43aa6c1b4c9d4e55dbf8fbbb6f&pb=U2FsdGVkX19f9PFmNxCRFJeax_BDuYbdFShdINzvLbeRBFN0SgqiDR2iep3H6C0ocXAR2ptuoZmDwu3jv7c_YNJotk6bK0qao11Kz9h8ZAEKaqRxnXtZM9w_4tXy_0R2">

 ### 4.2. На iPhone (реальном устройстве)
 > [!WARNING]  
 > В силу "закрытости" системы iOS, данный процесс (с нуля) может занять значительное количество времени.
 > Рекоммендуем ознакомиться со следующими инструкциями:
 > 
 > * [[Medium] How to run an app on your phone from Xcode](https://medium.com/@jpmtech/run-my-app-on-my-phone-from-xcode-7c56e01d6122)
 > 
 > * [[Apple] Enabling Developer Mode on a device](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device#:%7E:text=As%20indicated%20by%20the%20alert%2C%20to,and%20use%20the%20“Developer%20Mode”%20switch.)
 > 
 > * [[Apple] Running your app on a device](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)
 
 ### 5. Build and Run
 Убеждаемся, что для запуска выбрана ```scheme``` приложения, а не подмодуль.
 
 Нажимаем кнопку **Run** (Start the active scheme) в левом верхнем углу. 

 > [!TIP]
 > Запустить сборку и инсталляцию приложения можно с помощью сочетания клавишь **command+R**.

 <img title="Buld and run app" alt="Build and run" src="https://s810sas.storage.yandex.net/rdisk/f3f4cab66b062dd3a19e8ac0066332d4f68231b45770ef26b0af7a23a5c44fa6/6703ea0b/fKqInKw3d7bLFOeFnMGnhAxGMcy3dv49X-Rya5HzCm9o5osibd1JHpDGaHO3JWB-alBnkjoAdBPBHpZYYKRuOaAXiRCFM_VQK1fUJp7Zug6r8npumZHI4midPdWhecNq?uid=1130000067515093&filename=build_and_run.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=354945&hid=c05bdc2b76f7c413d05ccbefcbddc303&media_type=image&tknv=v2&etag=48cb78abf39681ce9d59c82011cf4690&ts=623e379f658c0&s=33b672a4789deaaefc88dbd4a0dd29ba63f8b5cde6912c56f85ab8bc1941425d&pb=U2FsdGVkX19eLczfs37EVtbZR35VDbL30LG3vqPAy-65aXGL9mycd2_QhuiAGIgNSz-7Wp62d_vpGjPqs5PqTfkoI1_lkRmgWMMQ9d6pjPrvnAvX4TCqbe9_hVTwuQf4">

 > [!TIP]
 > Индикатором успешного начала сборки и запуска приложения будет изменения статуса верхней панели на **Building**.

<p align="center">
<img src="https://s419vla.storage.yandex.net/rdisk/fa19de368473fe4d1a186ee1a1db7f2ec539c3a256ff46a681750cd52b54f3cc/6703ec2b/fKqInKw3d7bLFOeFnMGnhBDYiLwLs4WVYYbWn9tOUiAXLfI0mcyAVl5UWyMxWDrUePtTD2lY92lmvLsZCWwYMcKRNxk9YGZKq1BB7r4n8zCr8npumZHI4midPdWhecNq?uid=1130000067515093&filename=simulator.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=1130000067515093&fsize=717277&hid=93ca220f08f67ba71d59038c3631fb78&media_type=image&tknv=v2&etag=d25e7caf2dc395046d63d36c823add50&ts=623e39a6320c0&s=740df22792a6b5bb1a9a99ea9508c58b3cca69d9d861a0f52ed74e2ffe1604ed&pb=U2FsdGVkX19ggkBvTF2aP_1m63Si2Ct4N28aO2KWPyiCH0x68pQZZzdFQ6K3wHLeVpJ-n6poe8Atha5BC6ImkXdDfEfmz-sMFZPzBJZ9lFYSWuLIqbK0azjxvjFdMN49" "alt="simulator" width="200"/>
</p>
<p style="text-align:center;">Поздравляем! Приложение успешно запущено.</p>
