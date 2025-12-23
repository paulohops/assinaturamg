<?php require_once 'partials/header.php'; ?>

<div class="card">
    <h2>Preencha seus dados</h2>

    <form method="post" action="gera.php">

        <div class="form-group">
            <label>Nome completo</label>
            <input type="text" name="nome" required>
        </div>

        <div class="form-group">
            <label>Cargo</label>
            <input type="text" name="cargo" required>
        </div>

        <div class="form-group">
            <label>Telefone</label>
            <input type="text" name="telefone" id="telefone"
                   placeholder="(00) 0 0000-0000"
                   maxlength="16" required>
        </div>

        <button type="submit">Gerar assinatura</button>
    </form>
</div>

<script>
document.getElementById('telefone').addEventListener('input', function (e) {
    let v = e.target.value.replace(/\D/g, '').slice(0,11);
    let r = '';

    if (v.length > 0) r = '(' + v.substring(0,2);
    if (v.length >= 3) r += ') ' + v.substring(2,3);
    if (v.length >= 4) r += ' ' + v.substring(3,7);
    if (v.length >= 8) r += '-' + v.substring(7,11);

    e.target.value = r;
});
</script>

<?php require_once 'partials/footer.php'; ?>
