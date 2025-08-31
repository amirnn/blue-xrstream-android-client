import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.bluecpp.bluexrstream"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.bluecpp.bluexrstream"
        minSdk = 34
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        ndk {
            abiFilters.addAll(listOf("x86_64", "arm64-v8a"))
        }
        externalNativeBuild {
            cmake {
                val androidSdkPath = System.getenv("ANDROID_SDK_PATH").replace('\\', '/')
                arguments += listOf(
                    "-DGRADLE_BUILD_INITITIATED=TRUE",
                    // OpenCV specific options
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_PERF_TESTS=OFF",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DOPENCV_TEST_DNN_TFLITE=OFF",
                    "-DBUILD_ANDROID_EXAMPLE=OFF",
                    // Libdatachannel specific options
                    "-DANDROID_OPENSSL_ROOT=$androidSdkPath/android_openssl/ssl_3",
                    "-DOPENSSL_INCLUDE_DIR=$androidSdkPath/android_openssl/ssl_3/include",
                    "-DNO_EXAMPLES=TRUE",
                    "-DNO_TESTS=TRUE",
                    "-DLIBSRTP_TEST_APPS=FALSE"
                )
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    buildFeatures {
        prefab = true
    }
    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "4.1.0"
        }
    }
    ndkVersion = "29.0.13846066 rc3"
    buildToolsVersion = "36.0.0"
    kotlin {
        compilerOptions {
            jvmTarget = JvmTarget.JVM_21
        }
    }
}



dependencies {

    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.games.activity)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}