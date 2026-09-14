//go:build !debug

package parentcheck

import (
	"log"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

// ARSMAG: имя GUI-процесса, который единственный вправе запускать ядро.
// Должно совпадать с именем таргета в CMakeLists.txt (qt_add_executable)
// и с именем файла, который кладут установщик и deploy-скрипты.
//
// Вынесено в константу намеренно. При переименовании продукта это место
// легко пропустить: ни компилятор, ни какая-либо статическая проверка
// расхождения не увидят, ядро просто откажется стартовать в рантайме
// с "parent check failed". Так и произошло при ребрендинге Throne -> ArsLink.
const (
	expectedParentWindows = "ArsLink.exe"
	expectedParentUnix    = "ArsLink"
)

func CheckParentProcess() {
	parentPath, err := getParentExePath(ParentPID)
	if err != nil {
		log.Fatalf("parent check: cannot read parent executable: %v", err)
	}
	parentPath = resolveFinalPath(parentPath)

	selfPath, err := os.Executable()
	if err != nil {
		log.Fatalf("parent check: cannot read own executable: %v", err)
	}
	selfPath = resolveFinalPath(selfPath)

	selfDir := filepath.Dir(selfPath)
	parentDir := filepath.Dir(parentPath)
	parentBase := filepath.Base(parentPath)

	if runtime.GOOS == "windows" {
		if !strings.EqualFold(parentDir, selfDir) || !strings.EqualFold(parentBase, expectedParentWindows) {
			log.Fatalf("parent check failed: unexpected parent %q, selfPath is %q", parentPath, selfPath)
		}
		return
	}

	if parentDir != selfDir || parentBase != expectedParentUnix {
		log.Fatalf("parent check failed: unexpected parent %q, selfPath is %q", parentPath, selfPath)
	}
}
