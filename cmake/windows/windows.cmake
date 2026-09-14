set(PLATFORM_SOURCES 3rdparty/WinCommander.cpp src/sys/windows/guihelper.cpp src/sys/windows/MiniDump.cpp src/sys/windows/eventHandler.cpp src/sys/windows/WinVersion.cpp src/sys/windows/AutoRun.cpp src/sys/windows/UrlScheme.cpp)
set(PLATFORM_LIBRARIES wininet wsock32 ws2_32 user32 rasapi32 iphlpapi ntdll wbemuuid psapi shell32)

include(cmake/windows/generate_product_version.cmake)

# ARSMAG: настоящая версия сборки в свойствах файла вместо апстримного 1.0.0.0.
# Источник — тот же, что у версии, которую показывает сама программа: переменная
# окружения INPUT_VERSION, из неё cmake/nkr.cmake делает NKR_VERSION. Читаем её
# здесь напрямую, потому что nkr.cmake подключается ниже по CMakeLists, когда
# этот файл уже отработал.
#
# VERSIONINFO хранит версию четырьмя 16-битными числами, а INPUT_VERSION — строка
# вида "0.0.0-ci.42" или "1.2.4". Берём из неё все группы цифр по порядку,
# недостающие дополняем нулями, лишние отбрасываем. Каждое число ограничиваем
# 65535: большее не влезает в поле VERSIONINFO. Ведущие нули срезаем — иначе
# rc.exe прочитает "007" как восьмеричное.
set(ARSLINK_VERSION_RAW "$ENV{INPUT_VERSION}")
string(REGEX MATCHALL "[0-9]+" ARSLINK_VERSION_PARTS "${ARSLINK_VERSION_RAW}")
list(APPEND ARSLINK_VERSION_PARTS 0 0 0 0)
set(ARSLINK_VERSION_NUMS "")
foreach (_arslink_i RANGE 3)
    list(GET ARSLINK_VERSION_PARTS ${_arslink_i} _arslink_part)
    string(REGEX REPLACE "^0+" "" _arslink_part "${_arslink_part}")
    if (_arslink_part STREQUAL "")
        set(_arslink_part 0)
    endif ()
    if (_arslink_part GREATER 65535)
        set(_arslink_part 65535)
    endif ()
    list(APPEND ARSLINK_VERSION_NUMS ${_arslink_part})
endforeach ()
list(GET ARSLINK_VERSION_NUMS 0 ARSLINK_VERSION_MAJOR)
list(GET ARSLINK_VERSION_NUMS 1 ARSLINK_VERSION_MINOR)
list(GET ARSLINK_VERSION_NUMS 2 ARSLINK_VERSION_PATCH)
list(GET ARSLINK_VERSION_NUMS 3 ARSLINK_VERSION_REVISION)
message("[ArsLink] INPUT_VERSION='${ARSLINK_VERSION_RAW}' -> версия в свойствах файла ${ARSLINK_VERSION_MAJOR}.${ARSLINK_VERSION_MINOR}.${ARSLINK_VERSION_PATCH}.${ARSLINK_VERSION_REVISION}")

# ARSMAG: имя продукта — ArsLink. Поля, определяющие продукт (NAME, BUNDLE,
# COMPANY_NAME, FILE_DESCRIPTION), имени Throne не содержат. Атрибуция
# оригинальных авторов вынесена в LegalCopyright и Comments: это требование
# GPL-3.0 и наш аргумент при модерации. Строки только ASCII — VersionResource.rc
# собирается rc.exe, и не-ASCII в narrow-литералах здесь ненадёжен.
# Путь к иконке сохраняет имя файла res/Throne.ico сознательно (см. IZMENENIYA.md).
generate_product_version(
        QV2RAY_RC
        ICON "${CMAKE_SOURCE_DIR}/res/Throne.ico"
        VERSION_MAJOR ${ARSLINK_VERSION_MAJOR}
        VERSION_MINOR ${ARSLINK_VERSION_MINOR}
        VERSION_PATCH ${ARSLINK_VERSION_PATCH}
        VERSION_REVISION ${ARSLINK_VERSION_REVISION}
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
