#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/comopose#@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/compose#.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/compose#@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/compose#hover.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/compose#hover@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeAt.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeAt@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeAthover.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeAthover@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeCameraEnable.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeCameraEnable@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeCamerahover.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeCamerahover@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composedingwei.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composedingwei@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composedingweihover.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composedingweihover@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeEmotionBg.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeEmotionBg@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composehuatiinput.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composehuatiinput@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeiconbg.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeiconbg@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeImageDel.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeImageDel@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeImageFrame.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeImageFrame@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeloadingbtn.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeloadingbtn@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composepic_biankuang.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composepic_biankuang@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composequxiaobtn.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composequxiaobtn@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composereturnbtn.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composereturnbtn@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composesentbtn.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composesentbtn@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composesentbtnhover.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composesentbtnhover@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeupbg.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeupbg@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composevideo_pic.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composevideo_pic@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeWords.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/composeWords@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/friendPortrait.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/friendPortrait@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/netError.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/netError@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/repeatVideoStarticon.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/repeatVideoStarticon@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/separatorLine.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/separatorLine@2x.png"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/en.lproj"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/zh-Hans.lproj"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/zh-Hant.lproj"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/AVOSCloudUI.bundle"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/SinaWeibo.bundle"
install_resource "AVOSCloudUI/iOS/release-v2.1.2/AVOSCloudUI.framework/Versions/A/Resources/SVProgressHUD.bundle"
install_resource "Facebook-iOS-SDK/src/FBUserSettingsViewResources.bundle"
install_resource "PBJVision/Source/Shaders/Shader.fsh"
install_resource "PBJVision/Source/Shaders/Shader.vsh"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundError.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundError@2x.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundErrorIcon.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundErrorIcon@2x.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundMessage.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundMessage@2x.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundSuccess.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundSuccess@2x.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundSuccessIcon.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundSuccessIcon@2x.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundWarning.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundWarning@2x.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundWarningIcon.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationBackgroundWarningIcon@2x.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationButtonBackground.png"
install_resource "TSMessages/TSMessages/Resources/Images/NotificationButtonBackground@2x.png"
install_resource "TSMessages/TSMessages/Resources/TSMessagesDefaultDesign.json"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ `xcrun --find actool` ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in 
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;  
  esac 
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
