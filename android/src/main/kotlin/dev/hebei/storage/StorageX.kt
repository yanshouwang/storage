package dev.hebei.storage

import android.content.Context

val Context.userId: Int
    get() {
        val clazz = Context::class.java
        return clazz.getMethod("getUserId").invoke(this) as Int
    }