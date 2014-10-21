

defineReplace(addResourcesDeployment) {
    resource_files = $$files($$PWD/*)
    resource_files -= $$_FILE_

    unix {
        copyCommand = ""

        macx {
            target = $$OUT_PWD/$${TARGET}.app/Contents/Resources
        } else {
            target = $$OUT_PWD
        }

        target = $$replace(target, \\\\, /)
        !isEqual(source, $$target) {
            !isEmpty(copyCommand):copyCommand += &&
            copyCommand += $(MKDIR) \"$$target\"
            copyCommand += && $(COPY_DIR) $$resource_files \"$$target\"
        }

        !isEmpty(copyCommand) {
            copyCommand = @echo Copying application data... && $$copyCommand
            copydeploymentfolders.commands = $$copyCommand
            first.depends = $(first) copydeploymentfolders
            export (first.depends)
            export (copydeploymentfolders.commands)
            QMAKE_EXTRA_TARGETS += first copydeploymentfolders
        }
    }

    export (QMAKE_EXTRA_TARGETS)

    return ($$resource_files)
}

OTHER_FILES += $$addResourcesDeployment()
