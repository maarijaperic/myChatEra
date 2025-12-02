allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Force all subprojects to use Java 11
    afterEvaluate {
        // Force Java 11 for all Java compilation tasks
        tasks.withType<org.gradle.api.tasks.compile.JavaCompile>().configureEach {
            sourceCompatibility = "11"
            targetCompatibility = "11"
            options.compilerArgs.add("-Xlint:-options") // Suppress obsolete options warnings
        }
        
        // Force Java 11 for Android projects
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val compileOptions = android.javaClass.getMethod("getCompileOptions").invoke(android)
                    compileOptions.javaClass.getMethod("setSourceCompatibility", String::class.java).invoke(compileOptions, "11")
                    compileOptions.javaClass.getMethod("setTargetCompatibility", String::class.java).invoke(compileOptions, "11")
                } catch (e: Exception) {
                    // Ignore if method doesn't exist
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
