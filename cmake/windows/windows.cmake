set(PLATFORM_SOURCES 3rdparty/WinCommander.cpp src/sys/windows/guihelper.cpp src/sys/windows/MiniDump.cpp src/sys/windows/eventHandler.cpp src/sys/windows/WinVersion.cpp src/sys/windows/AutoRun.cpp src/sys/windows/UrlScheme.cpp)
set(PLATFORM_LIBRARIES wininet wsock32 ws2_32 user32 rasapi32 iphlpapi ntdll wbemuuid psapi shell32)

include(cmake/windows/generate_product_version.cmake)
# ARSMAG: имя продукта — ArsLink. Поля, определяющие продукт (NAME, BUNDLE,
# COMPANY_NAME, FILE_DESCRIPTION), имени Throne не содержат. Атрибуция
# оригинальных авторов вынесена в LegalCopyright и Comments: это требование
# GPL-3.0 и наш аргумент при модерации. Строки только ASCII — VersionResource.rc
# собирается rc.exe, и не-ASCII в narrow-литералах здесь ненадёжен.
# Путь к иконке сохраняет имя файла res/Throne.ico сознательно (см. IZMENENIYA.md).
generate_product_version(
        QV2RAY_RC
        ICON "${CMAKE_SOURCE_DIR}/res/Throne.ico"
        NAME "ArsLink"
        BUNDLE "ArsLink"
        COMPANY_NAME "ArsLink"
        COMPANY_COPYRIGHT "Copyright (C) 2026 ArsLink. Based on Throne, Copyright (C) Throne contributors. Licensed under GPL-3.0."
        COMMENTS "Based on Throne (https://github.com/throneproj/Throne), GPL-3.0."
        FILE_DESCRIPTION "ArsLink"
)
add_definitions(-DUNICODE -D_UNICODE -DNOMINMAX)
set(GUI_TYPE WIN32)
if (MSVC)
    add_compile_options("/utf-8")
    add_definitions(-D_WIN32_WINNT=0x600 -D_SCL_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_WARNINGS)
endif ()
